//
//  PhotosViewModel.swift
//  PhotosApp
//
//  Created by Amr Muhammad on 12/11/21.
//  Copyright © 2021 Amr Muhammad. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

class PhotosViewModel : PhotosViewModelContract{
    var items: BehaviorRelay<PhotoModel>
    var fetchMoreDatas: PublishSubject<Void>
    var refreshControlCompelted: PublishSubject<Void>
    var isLoadingSpinnerAvaliable: PublishSubject<Bool>
    var refreshControlAction: PublishSubject<Void>
    var errorObservable: Observable<(String)>
    var loadingObservable: Observable<Bool>
    
    private var errorsubject = PublishSubject<String>()
    private var loadingsubject = PublishSubject<Bool>()
    private var photosAPI:PhotosAPIContract!
    
    
    var limit = 5
    private var disposeBag:DisposeBag
    private var pageCounter = 1
    private var isPaginationRequestStillResume = false
    private var isRefreshRequstStillResume = false
    
    
    init() {
        errorObservable = errorsubject.asObservable()
        loadingObservable = loadingsubject.asObservable()
        
        items = BehaviorRelay<PhotoModel>(value: [])
        
        fetchMoreDatas = PublishSubject<Void>()
        refreshControlAction = PublishSubject<Void>()
        refreshControlCompelted = PublishSubject<Void>()
        isLoadingSpinnerAvaliable = PublishSubject<Bool>()
        
        photosAPI = PhotosAPI.sharedInstance
        disposeBag = DisposeBag()
        
        bind()
    }
    
    private func bind() {
        fetchMoreDatas.subscribe { [weak self] _ in
            guard let self = self else { return }
            self.fetchDummyData(page: self.pageCounter,
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
        fetchDummyData(page: pageCounter,
                       isRefreshControl: true)
    }
    
    
    private func fetchDummyData(page: Int, isRefreshControl: Bool) {
        if isPaginationRequestStillResume || isRefreshRequstStillResume { return }
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
                self.loadingsubject.onNext(false)
                self.handleDummyData(data: photosArray)
            case .failure(let error):
                self.loadingsubject.onNext(false)
                self.errorsubject.onNext(error.localizedDescription)
            }
            self.isLoadingSpinnerAvaliable.onNext(false)
            self.isPaginationRequestStillResume = false
            self.isRefreshRequstStillResume = false
            self.refreshControlCompelted.onNext(())
        }
    }
    
    private func handleDummyData(data: PhotoModel?) {
        var newData = data
        newData?.append(PhotoModelElement(id: "-1", author: "Added Placeholder", width: 4, height: 5, url: "", downloadURL: ""))
        if pageCounter == 1 {
            items.accept(newData ?? [])
        } else {
            let oldDatas = items.value
            items.accept(oldDatas + (newData ?? []))
        }
        pageCounter += 1
    }
}
