//
//  BCRankCell.swift
//  BCSwiftDemo
//
//  Created by NewUser on 2018/7/12.
//  Copyright © 2018年 Shine. All rights reserved.
//

import UIKit

class BCRankCell: BCBaseCollectionViewCell {
    
    var rankModel: RankingModel? {
        didSet {
            guard let model = rankModel else {
                return
            }
            iconView.kf.setBCImage(urlString: model.cover)
            titleLabel.text = "\(model.title!)榜"
            descLabel.text = model.subTitle
        }
    }
    
    private lazy var iconView: UIImageView = {
        let iw = UIImageView()
        iw.contentMode = .scaleAspectFill
        iw.clipsToBounds = true
        return iw
    }()
    
    lazy var titleLabel: UILabel = {
        let tl = UILabel()
        tl.textColor = UIColor.black
        tl.font = UIFont.systemFont(ofSize: 18)
        return tl
    }()
    
    private lazy var descLabel: UILabel = {
        let dl = UILabel()
        dl.textColor = UIColor.gray
        dl.font = UIFont.systemFont(ofSize: 14)
        dl.numberOfLines = 0
        return dl
    }()
    
    override func configUI() {
        backgroundColor = UIColor.white
        addSubview(iconView)
        iconView.snp.makeConstraints {
            $0.left.top.equalTo(10)
            $0.bottom.equalToSuperview().offset(-10)
            $0.width.equalTo(kScreenWidth/2.0)
        }
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.left.equalTo(iconView.snp.right).offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.height.equalTo(30)
            $0.top.equalTo(iconView).offset(20)
        }
        
        addSubview(descLabel)
        descLabel.snp.makeConstraints {
            $0.left.equalTo(iconView.snp.right).offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.bottom.equalTo(iconView)
        }
    }
}
