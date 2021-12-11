//
//  PhotosViewModel.swift
//  PhotosApp
//
//  Created by Amr Muhammad on 12/11/21.
//  Copyright © 2021 Amr Muhammad. All rights reserved.
//

import Foundation
import RxSwift

class PhotosViewModel : PhotosViewModelContract{
    
    private var errorsubject = PublishSubject<String>()
    private var loadingsubject = PublishSubject<Bool>()
    private var dataSubject = PublishSubject<PhotoModel>()
    private var photosAPI:PhotosAPIContract!

    var dataObservable: Observable<PhotoModel>
    var errorObservable: Observable<(String)>
    var loadingObservable: Observable<Bool>
    
    
    init() {
        dataObservable = dataSubject.asObservable()
        errorObservable = errorsubject.asObservable()
        loadingObservable = loadingsubject.asObservable()
        
        photosAPI = PhotosAPI.sharedInstance
    }
    
    func fetchPhotos(page: String, limit: String) {
        loadingsubject.onNext(true)
        photosAPI.getPhotos(page: page, limit: limit) {[weak self] (result) in
            guard let self = self else{
                print("PVM* getPhotos failed")
                return
            }
            switch result{
            case .success(let photosArray):
                self.loadingsubject.onNext(false)
                self.dataSubject.onNext(photosArray ?? [])
            case .failure(let error):
                self.loadingsubject.onNext(false)
                self.errorsubject.onNext(error.localizedDescription)
            }
        }
    }
    
}
