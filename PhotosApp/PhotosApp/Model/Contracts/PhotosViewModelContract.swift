//
//  PhotosViewModelContract.swift
//  PhotosApp
//
//  Created by Amr Muhammad on 12/11/21.
//  Copyright © 2021 Amr Muhammad. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

protocol PhotosViewModelContract : BaseViewModelContract {
    var items: BehaviorRelay<PhotoModel> {get}
    var fetchMoreDatas: PublishSubject<Void> {get}
    var refreshControlCompelted : PublishSubject<Void> {get}
    var isLoadingSpinnerAvaliable : PublishSubject<Bool> {get}
    var refreshControlAction : PublishSubject<Void> {get}

}
