//
//  BoutiListBannerCell.swift
//  BCSwiftDemo
//
//  Created by NewUser on 2018/7/6.
//  Copyright © 2018年 Shine. All rights reserved.
//

import UIKit
import Kingfisher

class BoutiListBannerCell: UICollectionViewCell {

    @IBOutlet weak var cellBgImageV: UIImageView!
    
    var model: GalleryItemModel? {
        didSet {
            if let cellModel = model {
                let url = URL(string: cellModel.cover ?? "")
                cellBgImageV.kf.setImage(with: url)
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
