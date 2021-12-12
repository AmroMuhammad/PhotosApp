//
//  PhotosRepositoryContract.swift
//  PhotosApp
//
//  Created by Amr Muhammad on 12/11/21.
//  Copyright © 2021 Amr Muhammad. All rights reserved.
//

import Foundation
import RxSwift

protocol PhotosRepositoryContract : PhotosViewModelContract{
    var dataObservable:Observable<PhotoModel> {get}
}
