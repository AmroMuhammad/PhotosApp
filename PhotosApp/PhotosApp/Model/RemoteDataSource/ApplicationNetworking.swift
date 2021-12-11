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
    case getProductDetails(id:String)
    case getMenCategoryProducts
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
        case .getProductDetails(_):
            return Constants.baseURL
            
        case .getMenCategoryProducts:
            return Constants.baseURL
            
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
        case .getProductDetails:
            return .requestPlain
            
        case .getMenCategoryProducts:
            return .requestPlain
        }
    }
    var headers: [String : String]? {
        switch self{
        default:
            return ["Accept": "application/json","Content-Type": "application/json"]
        }
    }
}
