//
//  BaseViewController.swift
//  PhotosApp
//
//  Created by Amr Muhammad on 12/10/21.
//  Copyright © 2021 Amr Muhammad. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    private var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func showLoading() {
        activityIndicator.center = self.view.center
        activityIndicator.color = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
        self.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    func hideLoading() {
        activityIndicator.stopAnimating()
    }
    
    func showAlert(title:String,body:String,actions:[UIAlertAction]){
        let alert = UIAlertController(title: title, message: body, preferredStyle: UIAlertController.Style.alert)
        for action in actions{
            alert.addAction(action)
        }
        present(alert, animated: true, completion: nil)
    }


}
