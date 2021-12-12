//
//  PhotosAPIContract.swift
//  PhotosApp
//
//  Created by Amr Muhammad on 12/11/21.
//  Copyright © 2021 Amr Muhammad. All rights reserved.
//

import Foundation
protocol PhotosAPIContract {
    func getPhotos(page:String,limit:String,completion: @escaping (Result<PhotoModel?,NSError>) -> Void)
    func cancelAllRequests()
}
