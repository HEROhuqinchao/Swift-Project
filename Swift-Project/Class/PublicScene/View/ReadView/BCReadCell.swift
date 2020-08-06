//
//  BCReadCell.swift
//  BCSwiftDemo
//
//  Created by NewUser on 2018/8/2.
//  Copyright © 2018年 Shine. All rights reserved.
//

import UIKit

extension UIImageView: Placeholder {}

class BCReadCell: BCBaseCollectionViewCell {
    
    lazy var readImageView: UIImageView = {
        let iw = UIImageView()
        iw.contentMode = .scaleAspectFit
        return iw
    }()
    
    lazy var placeholder: UIImageView = {
        let pr = UIImageView(image: #imageLiteral(resourceName: "yaofan"))
        pr.contentMode = .center
        return pr
    }()
    
    var model: ImageModel? {
        didSet {
            guard let iModel = model else { return }
            readImageView.image = nil
            readImageView.kf.setBCImage(urlString: iModel.location, placeholder: placeholder)
        }
    }
    
    
    override func configUI() {
        contentView.addSubview(readImageView)
        readImageView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
}
