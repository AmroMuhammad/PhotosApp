//
//  PhotoTableViewCell.swift
//  PhotosApp
//
//  Created by Amr Muhammad on 12/11/21.
//  Copyright © 2021 Amr Muhammad. All rights reserved.
//

import UIKit
import SDWebImage

class PhotoTableViewCell: UICollectionViewCell {
    @IBOutlet private weak var photoImageView: UIImageView!
    @IBOutlet private weak var authorLabel: UILabel!
    var photoModel:PhotoModelElement!{
        didSet{
            photoImageView.sd_setImage(with: URL(string: photoModel.downloadURL), placeholderImage: UIImage(named: "placeholder"))
            authorLabel.text = photoModel.author
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
