//
//  LoginViewModelContract.swift
//  PhotosApp
//
//  Created by Amr Muhammad on 12/10/21.
//  Copyright © 2021 Amr Muhammad. All rights reserved.
//

import Foundation
import RxSwift

protocol LoginViewModelContract : BaseViewModelContract {
    var signedInObservable: Observable<Bool> {get}
    func validateRegisterdData(phoneNumber:String,password:String)
    func checkForLoggingState()
}
