//  RegisterViewController.swift
//  Shopify e-commerce
//  Created by Ayman Omara on 30/05/2021.
//  Copyright © 2021 ITI41. All rights reserved.
import UIKit
import RxCocoa
import RxSwift

class RegisterViewController: BaseViewController {
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    private var registerViewModel:RegisterViewModelContract!
    private var disposeBag:DisposeBag!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        disposeBag = DisposeBag()
        self.title = "Regestration"
        passwordTextField.disableAutoFill()
        confirmPasswordTextField.disableAutoFill()
        
        registerViewModel = RegisterViewModel()

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
        
        registerViewModel.doneObservable.subscribe(onCompleted: {
            self.navigationController?.popViewController(animated: true)
            //TODO: amroo: add delegate here to send back phoneNumber after successfull register
            }).disposed(by: disposeBag)
    }
  
    @IBAction func didSubmitClicked(_ sender: Any) {
        registerViewModel.validateRegisterdData(phoneNumber: phoneNumberTextField.text!, password: passwordTextField.text!, confirmPassword: confirmPasswordTextField.text!)
    }
}
