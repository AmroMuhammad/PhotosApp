//
//  RegisterViewModel.swift
//  Shopify e-commerce
//
//  Created by Amr Muhammad on 6/10/21.
//  Copyright © 2021 ITI41. All rights reserved.
//

import Foundation
import RxSwift

class RegisterViewModel:RegisterViewModelContract{
    private var errorSubject = PublishSubject<(String)>()
    private var loadingsubject = PublishSubject<Bool>()
    private var doneSubject = PublishSubject<Bool>()
    
    var errorObservable: Observable<(String)>
    var loadingObservable: Observable<Bool>
    var doneObservable: Observable<Bool>

    init() {
        errorObservable = errorSubject.asObservable()
        loadingObservable = loadingsubject.asObservable()
        doneObservable = doneSubject.asObservable()
    }
    
    func validateRegisterdData(phoneNumber:String,password:String,confirmPassword:String){
        loadingsubject.onNext(true)
        if(phoneNumber.isEmpty || password.isEmpty || confirmPassword.isEmpty){
            errorSubject.onNext(Constants.emptyFieldsError)
        }else if(!phoneNumRegexCheck(text: phoneNumber)){
            errorSubject.onNext(Constants.phoneNumberError)
        }else if(password.count <= 5){
            errorSubject.onNext(Constants.passwordError)
        }else if(password != confirmPassword){
            errorSubject.onNext(Constants.passwordNotEqualError)
        }else{
            saveUser(user: User(phoneNumber: phoneNumber, password: password))
        }
        loadingsubject.onNext(false)
    }
    
    private func saveUser(user: User) {
        loadingsubject.onNext(true)
        UsersLocalDataSource.sharedInstance.fetchUser(byPhoneNumber: user.phoneNumber) {[weak self] (result) in
            guard let self = self else{
                print("RVM* error in saveUser")
                return
            }
            switch result{
            case .success(_):
                self.loadingsubject.onNext(false)
                self.errorSubject.onNext(Constants.userFoundError)
            case .failure(_):
                UsersLocalDataSource.sharedInstance.save(user: user) { (result) in
                    switch result{
                    case .success(_):
                        self.loadingsubject.onNext(false)
                        self.doneSubject.onCompleted()
                    case .failure(_):
                        self.loadingsubject.onNext(false)
                        self.errorSubject.onNext(Constants.genericError)
                    }
                }
                
            }
        }
    }
    
    private func phoneNumRegexCheck(text:String)->Bool{
        if(text.count != 11){
            return false
        }
        let range = NSRange(location: 0, length: text.utf16.count)
        let regex = try! NSRegularExpression(pattern: "[0-9]{11}$")
        if(regex.firstMatch(in: text, options: [], range: range) != nil){
            return true
        }else{
            return false
        }
    }
}
