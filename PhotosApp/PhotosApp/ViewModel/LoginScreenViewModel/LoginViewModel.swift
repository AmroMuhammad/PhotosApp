//
//  LoginViewModel.swift
//  PhotosApp
//
//  Created by Amr Muhammad on 12/10/21.
//  Copyright © 2021 Amr Muhammad. All rights reserved.

import Foundation
import RxSwift

class LoginViewModel : LoginViewModelContract{
    
    private var errorSubject = PublishSubject<(String)>()
    private var loadingSubject = PublishSubject<Bool>()
    private var signedInSubject = PublishSubject<Bool>()

    var errorObservable: Observable<(String)>
    var loadingObservable: Observable<Bool>
    var signedInObservable: Observable<Bool>

    
    init() {
        errorObservable = errorSubject.asObservable()
        loadingObservable = loadingSubject.asObservable()
        signedInObservable = signedInSubject.asObservable()
    }
    
    func validateRegisterdData(phoneNumber: String, password: String) {
        loadingSubject.onNext(true)
        if(phoneNumber.isEmpty || password.isEmpty){
            errorSubject.onNext(Constants.emptyFieldsError)
        }else if(!Utils.phoneNumRegexCheck(text: phoneNumber)){
            errorSubject.onNext(Constants.phoneNumberError)
        }else if(password.count <= 5){
            errorSubject.onNext(Constants.passwordError)
        }else{
            fetchUser(user: User(phoneNumber: phoneNumber, password: password))
        }
        loadingSubject.onNext(false)
    }
    
    private func fetchUser(user:User){
        loadingSubject.onNext(true)
        UsersLocalDataSource.sharedInstance.fetchUser(byPhoneNumber: user.phoneNumber) {[weak self] (result) in
            guard let self = self else{
                print("LVM* error in saveUser")
                return
            }
            switch result{
            case .success(let storedUser):
                self.loadingSubject.onNext(false)
                if(self.checkForPassword(storedUser: storedUser, inputUser: user)){
                    LocalUserDefaults.sharedInstance.changeLoggingState(loginState: true)
                    self.signedInSubject.onNext(true)
                }else{
                    self.errorSubject.onNext(Constants.loginPasswordError)
                }
            case .failure(_):
                self.loadingSubject.onNext(false)
                self.errorSubject.onNext(Constants.noUserError)
            }
        }
    }
    
    private func checkForPassword(storedUser:User,inputUser:User)->Bool{
        return storedUser.password == inputUser.password
    }
    
    func checkForLoggingState() {
        loadingSubject.onNext(true)
        if(LocalUserDefaults.sharedInstance.isLoggedIn()){
            self.signedInSubject.onNext(true)
        }
        loadingSubject.onNext(false)

    }
    
}
