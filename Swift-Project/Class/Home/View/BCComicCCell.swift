//
//  BCComicCCell.swift
//  BCSwiftDemo
//
//  Created by NewUser on 2018/7/6.
//  Copyright © 2018年 Shine. All rights reserved.
//

import UIKit

enum BCComicCCellStyle {
    case none //默认无字
    case withTitle //有字 宽
    case withTitieAndDesc // 有字 高
}

class BCComicCCell: BCBaseCollectionViewCell {
    
    var model: ComicModel? {
        didSet {
            guard let model = model else { return }
            iconView.kf.setBCImage(urlString: model.cover,
                                 placeholder: (bounds.width > bounds.height) ? UIImage(named: "normal_placeholder_h") : UIImage(named: "normal_placeholder_v"))
            titleLabel.text = model.name ?? model.title
            descLabel.text = model.subTitle ?? "更新至\(model.content ?? "0")集"
        }
    }
    
    var style: BCComicCCellStyle = .withTitle {
        didSet {
            updateSizeStyle()
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
        tl.font = UIFont.systemFont(ofSize: 14)
        return tl
    }()
    
    private lazy var descLabel: UILabel = {
        let dl = UILabel()
        dl.textColor = UIColor.gray
        dl.font = UIFont.systemFont(ofSize: 12)
        return dl
    }()
    
    override func configUI() {
        clipsToBounds = true
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
            $0.height.equalTo(25)
            $0.bottom.equalToSuperview().offset(-10)
        }
        
        contentView.addSubview(iconView)
        iconView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.bottom.equalTo(titleLabel.snp.top)
        }
        
        contentView.addSubview(descLabel)
        descLabel.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
            $0.height.equalTo(20)
            $0.top.equalTo(titleLabel.snp.bottom)
        }
    }
    
    fileprivate func updateSizeStyle() {
        switch style {
        case .none:
            titleLabel.snp.updateConstraints {
                $0.bottom.equalToSuperview().offset(25)
            }
            titleLabel.isHidden = true
            descLabel.isHidden = true
        case .withTitle:
            titleLabel.snp.updateConstraints{
                $0.bottom.equalToSuperview().offset(-10)
            }
            titleLabel.isHidden = false
            descLabel.isHidden = true
        case .withTitieAndDesc:
            titleLabel.snp.updateConstraints{
                $0.bottom.equalToSuperview().offset(-25)
            }
            titleLabel.isHidden = false
            descLabel.isHidden = false
        }
    }
}
