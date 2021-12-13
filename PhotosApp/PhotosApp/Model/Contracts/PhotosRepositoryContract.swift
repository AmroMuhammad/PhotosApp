//
//  PhotosRepositoryContract.swift
//  PhotosApp
//
//  Created by Amr Muhammad on 12/11/21.
//  Copyright © 2021 Amr Muhammad. All rights reserved.
//

import Foundation
import RxSwift

protocol PhotosRepositoryContract : BaseViewModelContract ,PaginationContract{
    var dataObservable:Observable<PhotoModel> {get}
}
