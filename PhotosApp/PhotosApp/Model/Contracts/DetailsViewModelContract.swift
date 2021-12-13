//
//  DetailsViewModelContract.swift
//  PhotosApp
//
//  Created by Amr Muhammad on 12/12/21.
//  Copyright © 2021 Amr Muhammad. All rights reserved.
//

import Foundation
import RxSwift
protocol DetailsViewModelContract:BaseViewModelContract{
    func getDominantColor(image:UIImage?)
    var colorObservable:Observable<UIColor> {get}
}
