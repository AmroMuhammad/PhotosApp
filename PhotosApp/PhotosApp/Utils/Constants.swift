//
//  Constants.swift
//  PhotosApp
//
//  Created by Amr Muhammad on 12/10/21.
//  Copyright © 2021 Amr Muhammad. All rights reserved.
//

import Foundation

struct Constants{
    static let usersDatabaseName = "Users"
    static let userPhone = "phoneNumber"
    static let userPassword = "password"
    static let genericError = "General Error occured, kindly try again later"
    static let databaseDomain = "databaseDomain"
    static let emptyFieldsError = "All Fields should be filled"
    static let phoneNumberError = "Phone Number should be 11 numbers"
    static let passwordError = "password should be more than 5 characters"
    static let passwordNotEqualError = "password is not the same as confirm password"
    static let noUserError = "No User Found"
    static let userFoundError = "User already Found"
    static let isLoggedInUserDefaults = "isLogged"
    static let loginVC = "LoginViewController"
    static let registerVC = "RegisterViewController"
    static let loginPasswordError = "Phone or password is wrong, please try again"
    static let baseURL = ""
}
