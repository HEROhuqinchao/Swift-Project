//
//  BCDescriptionCell.swift
//  BCSwiftDemo
//
//  Created by NewUser on 2018/7/30.
//  Copyright © 2018年 Shine. All rights reserved.
//

import UIKit

class BCDescriptionCell: BCBaseTableViewCell {

    var model: DetailStaticModel? {
        didSet{
            guard let model = model else { return }
            contentText.text = "【\(model.comic?.cate_id ?? "")】\(model.comic?.description ?? "")"
        }
    }
    
    lazy var descriTitle: UILabel = {
        let dl = UILabel()
        dl.text = "作品介绍"
        return dl
    }()

    lazy var contentText: UILabel = {
        let ct = UILabel()
        ct.textColor = UIColor.gray
        ct.font = UIFont.systemFont(ofSize: 15)
        ct.numberOfLines = 0
        return ct
    }()
    
    override func configUI() {
        contentView.addSubview(descriTitle)
        descriTitle.snp.makeConstraints {
            $0.top.left.right.equalToSuperview().inset(UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15))
            $0.height.equalTo(20)
        }
        
        contentView.addSubview(contentText)
        contentText.snp.makeConstraints {
            $0.top.equalTo(descriTitle.snp.bottom)
            $0.left.right.bottom.equalToSuperview().inset(UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15))
        }
    }
}
