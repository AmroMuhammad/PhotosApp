//
//  PhotosViewController.swift
//  PhotosApp
//
//  Created by Amr Muhammad on 12/10/21.
//  Copyright © 2021 Amr Muhammad. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class PhotosViewController: BaseViewController {
    @IBOutlet private weak var photosCollectionView: UICollectionView!
    
    private var disposeBag:DisposeBag!
    private var photosViewModel:PhotosViewModelContract!

    override func viewDidLoad() {
        super.viewDidLoad()

        registerCellNibFile()
        instantiateRXItems()
        
        listenOnObservables()
        
        photosViewModel.fetchPhotos(page: "1", limit: "10")

    }
    
    private func registerCellNibFile(){
        let photoNibCell = UINib(nibName: Constants.photoCellNibName, bundle: nil)
        photosCollectionView.register(photoNibCell, forCellWithReuseIdentifier: Constants.photoCellNibName)
    }
    
    private func instantiateRXItems(){
        disposeBag = DisposeBag()
        photosViewModel = PhotosViewModel()
        photosCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
    private func listenOnObservables(){
        photosViewModel.errorObservable.subscribe(onNext: {[weak self] (message) in
            guard let self = self else{
                print("PVC* error in errorObservable")
                return
            }
            self.showAlert(title: "Error", body: message, actions: [UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)])
            }).disposed(by: disposeBag)
        
        photosViewModel.loadingObservable.subscribe(onNext: {[weak self] (boolValue) in
            guard let self = self else{
                print("PVC* error in doneObservable")
                return
            }
            switch boolValue{
            case true:
                self.showLoading()
            case false:
                self.hideLoading()
            }
            }).disposed(by: disposeBag)
        
        photosViewModel.dataObservable.bind(to: photosCollectionView.rx.items(cellIdentifier: Constants.photoCellNibName)){ row,item,cell in
           let castedCell = cell as! PhotoTableViewCell
            castedCell.photoModel = item
        }.disposed(by: disposeBag)
    }
}

extension PhotosViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let requiredWidth = (collectionView.bounds.size.width-10)/2
        return CGSize(width: requiredWidth, height: requiredWidth)
    }
    
}

