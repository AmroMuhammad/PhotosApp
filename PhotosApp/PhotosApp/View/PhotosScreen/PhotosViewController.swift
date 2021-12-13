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
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        return refreshControl
    }()
    
    private var disposeBag:DisposeBag!
    private var photosViewModel:PhotosViewModelContract!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationController()
        registerCellNibFile()
        instantiateRXItems()
        
        listenOnObservables()
        instantiateRefreshControl()
        
    }
    
    private func setupNavigationController(){
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.title = "Photos Gallery"
        let button1 = UIBarButtonItem(image: UIImage(named: "logout"), style: .plain, target: self, action: #selector(logout))
        button1.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.navigationItem.rightBarButtonItem  = button1
    }
    
    @objc private func logout(){
        photosViewModel.logout()
        navigationController?.popViewController(animated: true)
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
    
    private func instantiateRefreshControl(){
        photosCollectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshControlTriggered), for: .valueChanged)
    }
    
    @objc private func refreshControlTriggered() {
        photosViewModel.refreshControlAction.onNext(())
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
        
        photosViewModel.items.bind(to: photosCollectionView.rx.items) { collectionView, row, item in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.photoCellNibName, for: IndexPath(index: row)) as! PhotoTableViewCell
            cell.photoModel = item
            return cell
        }
        .disposed(by: disposeBag)
        
        photosCollectionView.rx.didScroll.subscribe { [weak self] _ in
            guard let self = self else {
                print("PVC* error in didScroll")
                return }
            let offSetY = self.photosCollectionView.contentOffset.y
            let contentHeight = self.photosCollectionView.contentSize.height
            
            if offSetY > (contentHeight - self.photosCollectionView.frame.size.height - 20) {
                self.photosViewModel.fetchMoreDatas.onNext(())
            }
        }.disposed(by: disposeBag)
        
        photosViewModel.isLoadingSpinnerAvaliable.subscribe { [weak self] isAvaliable in
            guard let isAvaliable = isAvaliable.element,
                let self = self else { return }
            if(isAvaliable){
                self.showLoading()
            }else{
                self.hideLoading()
            }
        }
        .disposed(by: disposeBag)
        
        photosViewModel.refreshControlCompelted.subscribe { [weak self] _ in
            guard let self = self else { return }
            self.refreshControl.endRefreshing()
        }
        .disposed(by: disposeBag)
        
        photosCollectionView.rx.modelSelected(PhotoModelElement.self).subscribe(onNext: {[weak self] (photoItem) in
            guard let self = self else {return}
            guard let vc = self.storyboard?.instantiateViewController(identifier: Constants.detailsVC, creator: { coder in
                return DetailsViewController(coder: coder, photo: photoItem)
            }) else {
                fatalError("Failed to load EditUserViewController from storyboard.")
            }

            self.present(vc, animated: true, completion: nil)
        }).disposed(by: disposeBag)
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

