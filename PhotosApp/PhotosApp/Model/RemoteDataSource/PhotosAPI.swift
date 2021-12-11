//
//  PhotosAPI.swift
//  PhotosApp
//
//  Created by Amr Muhammad on 12/10/21.
//  Copyright © 2021 Amr Muhammad. All rights reserved.
//

import Foundation
import Alamofire


class PhotosAPI : BaseAPI<ApplicationNetworking>, PhotosAPIContract{
    
    //add protocol
    static let sharedInstance = PhotosAPI()
    
    private override init() {}

    func getPhotos(page: String, limit: String, completion: @escaping (Result<PhotoModel?, NSError>) -> Void) {
        self.fetchData(target: .getPhotos(page: page, limit: limit), responseClass: PhotoModelElement.self) { (result) in
            completion(result)
        }
    }

}

   
