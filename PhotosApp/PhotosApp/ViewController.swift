//
//  ViewController.swift
//  PhotosApp
//
//  Created by Amr Muhammad on 12/10/21.
//  Copyright © 2021 Amr Muhammad. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        PhotosAPI.sharedInstance.getPhotos(page: "1", limit: "5") { (result) in
            print("reeeeesult222222")
        }
    }


}

