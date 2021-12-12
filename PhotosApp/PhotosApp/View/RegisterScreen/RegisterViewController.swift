//
//  RegisterViewController.swift
//  PhotosApp
//
//  Created by Amr Muhammad on 12/10/21.
//  Copyright © 2021 Amr Muhammad. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class RegisterViewController: BaseViewController {
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    private var registerViewModel:RegisterViewModelContract!
    private var disposeBag:DisposeBag!
    weak var delegate:PhoneNumberVCDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        disposeBag = DisposeBag()
        
        passwordTextField.disableAutoFill()
        confirmPasswordTextField.disableAutoFill()
        
        registerViewModel = RegisterViewModel()
        
        listenOnObservables()
    }
    
    private func listenOnObservables(){
        registerViewModel.errorObservable.subscribe(onNext: {[weak self] (message) in
            guard let self = self else{
                print("RVC* error in errorObservable")
                return
            }
            self.showAlert(title: "Error", body: message, actions: [UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)])
            
            }).disposed(by: disposeBag)
        
        registerViewModel.loadingObservable.subscribe(onNext: {[weak self] (result) in
            guard let self = self else{
                print("RVC* error in loadingObservable")
                return
            }
            switch result{
            case true:
                self.showLoading()
            case false:
                self.hideLoading()
            }
            }).disposed(by: disposeBag)
        
        registerViewModel.doneObservable.subscribe(onNext: {[weak self] (user) in
            guard let self = self else{
                print("RVC* error in doneObservable")
                return
            }
            self.delegate.setPhoneNumber(phoneNumber: user.phoneNumber)
            self.navigationController?.popViewController(animated: true)
            }).disposed(by: disposeBag)
    }
  
    @IBAction func didSubmitClicked(_ sender: Any) {
        registerViewModel.validateRegisterdData(phoneNumber: phoneNumberTextField.text!, password: passwordTextField.text!, confirmPassword: confirmPasswordTextField.text!)
    }
}
