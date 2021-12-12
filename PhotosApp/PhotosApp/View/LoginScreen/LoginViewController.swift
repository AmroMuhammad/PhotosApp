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
                
        loginViewModel = LoginViewModel()
        disposeBag = DisposeBag()
        passwordTextField.disableAutoFill()

        listenOnObservables()
        loginViewModel.checkForLoggingState()
        
    }
    
    func listenOnObservables(){
        loginViewModel.errorObservable.subscribe(onNext: {[weak self] (message) in
            guard let self = self else{
                print("LVC* error in errorObservable")
                return
            }
            self.showAlert(title: "Error", body: message, actions: [UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)])
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
                print("amrooooooo111")
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
                self.navigateToHomeScreen()
            case false:
                print("LVC* signedInObservable failed")
            }
            }).disposed(by: disposeBag)
    }
    
    @IBAction func didLoginClicked(_ sender: Any) {
        loginViewModel.validateRegisterdData(phoneNumber: phoneNumberTextField.text!, password: passwordTextField.text!)
    }
    
    @IBAction func didRegisterClicked(_ sender: Any) {
        let registerVC = self.storyboard?.instantiateViewController(identifier: Constants.registerVC) as! RegisterViewController
        registerVC.delegate = self
        self.navigationController?.pushViewController(registerVC, animated: true)
    }
    
    private func navigateToHomeScreen(){
        let homeVC = self.storyboard?.instantiateViewController(identifier: Constants.photosVC) as! PhotosViewController
        phoneNumberTextField.text = ""
        self.navigationController?.pushViewController(homeVC, animated: true)
    }
    
}

extension LoginViewController : PhoneNumberVCDelegate{
    func setPhoneNumber(phoneNumber: String) {
        phoneNumberTextField.text = phoneNumber
    }
    
    
}
