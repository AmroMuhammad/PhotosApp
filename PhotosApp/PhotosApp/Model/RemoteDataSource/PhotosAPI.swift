//
//  PhotosAPI.swift
//  PhotosApp
//
//  Created by Amr Muhammad on 12/10/21.
//  Copyright © 2021 Amr Muhammad. All rights reserved.
//

import Foundation
import Alamofire


class PhotosAPI : BaseAPI<ApplicationNetworking>{
    //add protocol
    static let shared = PhotosAPI()
    
    private override init() {}

//    func getCustomers(completion: @escaping (Result<AllCustomers?,NSError>) -> Void) {
//            self.fetchData(target: .customers, responseClass: AllCustomers.self) { (results) in
//                completion(results)
//            }
//    }

}

   
