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
    
    private var disposeBag:DisposeBag
    private var repo:PhotosRepositoryContract
    
    
    init() {
        errorObservable = errorsubject.asObservable()
        loadingObservable = loadingsubject.asObservable()
        
        items = BehaviorRelay<PhotoModel>(value: [])
        
        fetchMoreDatas = PublishSubject<Void>()
        refreshControlAction = PublishSubject<Void>()
        refreshControlCompelted = PublishSubject<Void>()
        isLoadingSpinnerAvaliable = PublishSubject<Bool>()
        
        disposeBag = DisposeBag()
        
        repo = PhotosRepository()
        
        bind()
    }
    
    
    private func bind() {
        fetchMoreDatas.subscribe { [weak self] _ in
            guard let self = self else { return }
            self.repo.fetchMoreDatas.onNext(())
        }
        .disposed(by: disposeBag)
        
        refreshControlAction.subscribe { [weak self] _ in
            guard let self = self else { return }
            self.repo.refreshControlAction.onNext(())
        }
        .disposed(by: disposeBag)
        
        repo.dataObservable.subscribe(onNext: {[weak self] (photoArray) in
            guard let self = self else {return}
            self.items.accept(photoArray)
        }).disposed(by: disposeBag)
        
        repo.errorObservable.subscribe(onNext: {[weak self] (message) in
            guard let self = self else {return}
            self.errorsubject.onNext(message)
        }).disposed(by: disposeBag)
        
        repo.loadingObservable.subscribe(onNext: {[weak self] (bool) in
            guard let self = self else {return}
            self.loadingsubject.onNext(bool)
        }).disposed(by: disposeBag)
        
        repo.isLoadingSpinnerAvaliable.subscribe(onNext: {[weak self] (bool) in
            guard let self = self else {return}
            self.isLoadingSpinnerAvaliable.onNext(bool)
        }).disposed(by: disposeBag)
        
        repo.refreshControlCompelted.subscribe(onNext: {[weak self] (_) in
            guard let self = self else {return}
            self.refreshControlCompelted.onNext(())
        }).disposed(by: disposeBag)
        
    }
}
