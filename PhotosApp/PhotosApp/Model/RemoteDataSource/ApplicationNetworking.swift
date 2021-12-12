//
//  ApplicationAPI.swift
//  PhotosApp
//
//  Created by Amr Muhammad on 12/10/21.
//  Copyright © 2021 Amr Muhammad. All rights reserved.
//

import Foundation
import Alamofire

enum ApplicationNetworking{
    case getPhotos(page:String, limit:String)
}

extension ApplicationNetworking : TargetType{
    var baseURL: String {
        switch self{
        default:
            return Constants.baseURL
        }
    }
    
    var path: String {
        switch self{
        case .getPhotos:
            return Constants.urlPath
        }
    }
    
    var method: HTTPMethod {
        switch self{
        default:
            return .get
        }
    }
    
    var task: Task {
        switch self{
        case .getPhotos(let page, let limit):
            return .requestParameters(parameters: ["page":page,"limit":limit], encoding: URLEncoding.default)
        }
    }
    var headers: [String : String]? {
        switch self{
        default:
            return ["Accept": "application/json","Content-Type": "application/json"]
        }
    }
}
