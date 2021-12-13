//
//  DetailsViewModel.swift
//  PhotosApp
//
//  Created by Amr Muhammad on 12/12/21.
//  Copyright © 2021 Amr Muhammad. All rights reserved.
//

import UIKit
import RxSwift
class DetailsViewModel : DetailsViewModelContract{
    var colorObservable: Observable<UIColor>
    var errorObservable: Observable<(String)>
    var loadingObservable: Observable<Bool>
    
    private var colorSubject = PublishSubject<UIColor>()
    private var errorSubject = PublishSubject<String>()
    private var loadingSubject = PublishSubject<Bool>()
        
    init() {
        colorObservable = colorSubject.asObservable()
        errorObservable = errorSubject.asObservable()
        loadingObservable = loadingSubject.asObservable()
    }
    
    func getDominantColor(image:UIImage?) {
        loadingSubject.onNext(true)
        image?.getAverageColor(completion: {[weak self] (color) in
            guard let self = self else{return}
            DispatchQueue.main.async {
                self.colorSubject.onNext(color ?? #colorLiteral(red: 0.9294117647, green: 0.9279678464, blue: 0.8820918202, alpha: 1))
                self.loadingSubject.onNext(false)
            }
        })
    }
    
    private func instantiateRxObjects(){
        
    }
}

