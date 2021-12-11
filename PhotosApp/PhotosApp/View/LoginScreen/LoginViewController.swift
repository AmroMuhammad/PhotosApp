//
//  LoginViewController.swift
//  PhotosApp
//
//  Created by Amr Muhammad on 12/10/21.
//  Copyright © 2021 Amr Muhammad. All rights reserved.
//
import UIKit
import RxSwift
import RxCocoa

class LoginViewController: BaseViewController {
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    private var disposeBag:DisposeBag!
    private var loginViewModel:LoginViewModelContract!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Login"
        
        loginViewModel = LoginViewModel()
        disposeBag = DisposeBag()
        
        loginViewModel.errorObservable.subscribe(onNext: {[weak self] (message) in
            guard let self = self else{
                print("LVC* error in errorObservable")
                return
            }
            
            }).disposed(by: disposeBag)
        
        loginViewModel.loadingObservable.subscribe(onNext: {[weak self] (boolValue) in
            guard let self = self else{
                print("LVC* error in errorObservable")
                return
            }
            switch boolValue{
            case true:
                self.showLoading()
            case false:
                self.hideLoading()
            }
            }).disposed(by: disposeBag)
        
        loginViewModel.signedInObservable.subscribe(onNext: {[weak self] (boolValue) in
            guard let self = self else{
                print("LVC* error in errorObservable")
                return
            }
            switch boolValue{
            case true:
                print("asd")
            case false:
                print("asd")
            }
            }).disposed(by: disposeBag)
        
    }
    
    @IBAction func didLoginClicked(_ sender: Any) {
        loginViewModel.validateRegisterdData(phoneNumber: phoneNumberTextField.text!, password: passwordTextField.text!)
    }
    
    @IBAction func didRegisterClicked(_ sender: Any) {
    }
    
}
