//
//  DetailsViewController.swift
//  PhotosApp
//
//  Created by Amr Muhammad on 12/12/21.
//  Copyright © 2021 Amr Muhammad. All rights reserved.
//

import UIKit
import SDWebImage
import RxSwift

class DetailsViewController: BaseViewController {
    @IBOutlet private var mainView: UIView!
    @IBOutlet private weak var idLabel: UILabel!
    @IBOutlet private weak var authorLabel: UILabel!
    @IBOutlet private weak var widthLabel: UILabel!
    @IBOutlet private weak var heightLabel: UILabel!
    @IBOutlet private weak var urlLabel: UILabel!
    @IBOutlet private weak var downloadLabel: UILabel!
    @IBOutlet private weak var photoImageView: UIImageView!
    private var detailsViewModel:DetailsViewModelContract
    private var photo:PhotoModelElement
    private var disposeBag:DisposeBag
    
    init?(coder: NSCoder, photo: PhotoModelElement) {
        self.photo = photo
        detailsViewModel = DetailsViewModel()
        disposeBag = DisposeBag()
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("You must create this view controller with a user.")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showLoading()
        assignLabels()
        listenOnObservables()
    }
    
    private func listenOnObservables(){
        detailsViewModel.errorObservable.subscribe(onNext: {[weak self] (message) in
            guard let self = self else{
                print("DVC* error in errorObservable")
                return
            }
            self.showAlert(title: "Error", body: message, actions: [UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)])
        }).disposed(by: disposeBag)
        
        detailsViewModel.loadingObservable.subscribe(onNext: {[weak self] (boolValue) in
            guard let self = self else{
                print("DVC* error in doneObservable")
                return
            }
            switch boolValue{
            case true:
                self.showLoading()
            case false:
                self.hideLoading()
            }
        }).disposed(by: disposeBag)
        
        detailsViewModel.colorObservable.subscribe(onNext: { (color) in
            self.mainView.backgroundColor = color
            
        }).disposed(by: disposeBag)
    }
    
    private func assignLabels(){
        photoImageView.sd_setImage(with: URL(string: photo.downloadURL), placeholderImage: UIImage(named:"placeholder"))
        idLabel.text = photo.id
        authorLabel.text = photo.author
        widthLabel.text = "\(photo.width)"
        heightLabel.text = "\(photo.height)"
        urlLabel.text = photo.url
        downloadLabel.text = photo.downloadURL
        detailsViewModel.getDominantColor(image: self.photoImageView.image)
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
