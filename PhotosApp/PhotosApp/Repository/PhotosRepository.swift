//
//  PhotosRepository.swift
//  PhotosApp
//
//  Created by Amr Muhammad on 12/11/21.
//  Copyright © 2021 Amr Muhammad. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

class PhotosRepository: PhotosRepositoryContract{
    private var errorsubject = PublishSubject<String>()
    private var loadingsubject = PublishSubject<Bool>()
    private var dataSubject = PublishSubject<PhotoModel>()
    private var photosAPI:PhotosAPIContract!
    private var localDataSource:PhotosLocalDataSource
    private var disposeBag:DisposeBag
    private var pageCounter = 1
    private var isPaginationRequestStillResume = false
    private var isRefreshRequstStillResume = false
    private let limit = 5
    
    var fetchMoreDatas: PublishSubject<Void>
    var refreshControlCompelted: PublishSubject<Void>
    var isLoadingSpinnerAvaliable: PublishSubject<Bool>
    var refreshControlAction: PublishSubject<Void>
    var errorObservable: Observable<(String)>
    var loadingObservable: Observable<Bool>
    var dataObservable:Observable<PhotoModel>
    var items: BehaviorRelay<PhotoModel>
    
    init() {
        errorObservable = errorsubject.asObservable()
        loadingObservable = loadingsubject.asObservable()
        dataObservable = dataSubject.asObservable()
        items = BehaviorRelay<PhotoModel>(value: [])
        
        fetchMoreDatas = PublishSubject<Void>()
        refreshControlAction = PublishSubject<Void>()
        refreshControlCompelted = PublishSubject<Void>()
        isLoadingSpinnerAvaliable = PublishSubject<Bool>()
        
        photosAPI = PhotosAPI.sharedInstance
        localDataSource = PhotosLocalDataSource.sharedInstance
        disposeBag = DisposeBag()
        
        bind()
    }
    
    private func bind() {
        fetchMoreDatas.subscribe { [weak self] _ in
            guard let self = self else { return }
            self.fetchData(page: self.pageCounter,
                           isRefreshControl: false)
        }
        .disposed(by: disposeBag)
        
        refreshControlAction.subscribe { [weak self] _ in
            self?.refreshControlTriggered()
        }
        .disposed(by: disposeBag)
    }
    
    private func refreshControlTriggered() {
        photosAPI.cancelAllRequests()
        pageCounter = 1
        items.accept([])
        dataSubject.onNext([])
        fetchData(page: pageCounter,
                  isRefreshControl: true)
    }
    
    
    private func fetchData(page: Int, isRefreshControl: Bool) {
        self.loadingsubject.onNext(true)
        if isPaginationRequestStillResume || isRefreshRequstStillResume {
            return
        }
        self.isRefreshRequstStillResume = isRefreshControl
        
        isPaginationRequestStillResume = true
        isLoadingSpinnerAvaliable.onNext(true)
        
        if pageCounter == 1  || isRefreshControl {
            isLoadingSpinnerAvaliable.onNext(false)
        }
        
        photosAPI.getPhotos(page: String(pageCounter), limit: String(limit)) {[weak self] (result) in
            guard let self = self else{
                print("PVM* getPhotos failed")
                return
            }
            switch result{
            case .success(let photosArray):
                print("2")
                self.loadingsubject.onNext(false)
                self.handleData(data: photosArray)
            case .failure(let error):
                self.localDataSource.fetchAllPhotos { (photosArray) in
                    if let photosArray = photosArray {
                        print("amrooo123")
                        self.items.accept(photosArray)
                        self.dataSubject.onNext(photosArray)
                        return
                    }else{
                        print("3")
                        self.loadingsubject.onNext(false)
                        self.errorsubject.onNext(error.localizedDescription)
                    }
                }
            }
            self.isLoadingSpinnerAvaliable.onNext(false)
            self.isPaginationRequestStillResume = false
            self.isRefreshRequstStillResume = false
            self.refreshControlCompelted.onNext(())
        }
    }
    
    private func handleData(data: PhotoModel?) {
        print("in handle data")
        localDataSource.deleteAllData()
        var newData = data
        newData?.append(PhotoModelElement(id: "-1", author: "Added Placeholder", width: 4, height: 5, url: "", downloadURL: ""))
        if pageCounter != 1 {
            print("HD* pc !=1")
            let oldDatas = items.value
            newData = oldDatas + (newData ?? [])
        }
        localDataSource.save(photosArray: newData ?? []) {[weak self] (result) in
            guard let self = self  else{
                return
            }
            switch result{
            case .success(let bol):
                if(bol){
                    print("HD* in b=true")
                    self.items.accept(newData ?? [])
                    self.dataSubject.onNext(newData ?? [])
                }
            case .failure(let error):
                print("HD* in error")
                self.errorsubject.onNext(error.localizedDescription)
            }
        }
        pageCounter += 1
    }
    
}
