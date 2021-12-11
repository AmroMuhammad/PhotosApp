//
//  LocalUserDefault.swift
//  PhotosApp
//
//  Created by Amr Muhammad on 12/10/21.
//  Copyright © 2021 Amr Muhammad. All rights reserved.
//

import Foundation
class LocalUserDefaults{
    static let sharedInstance = LocalUserDefaults()
    private var userDefaults:UserDefaults
    
    private init(){
        userDefaults = UserDefaults.standard
    }
    
    func isLoggedIn()->Bool{
        let loggedIn = userDefaults.value(forKey: Constants.isLoggedInUserDefaults)
        if(loggedIn != nil){
            if(loggedIn as! Bool){
                return true
            }else{
                return false
            }
        }else{
            return false        }

    }
    
    func changeLoggingState(loginState:Bool){
        userDefaults.set(loginState, forKey: Constants.isLoggedInUserDefaults)
    }
}


