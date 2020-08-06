//
//  BCCommentCell.swift
//  BCSwiftDemo
//
//  Created by NewUser on 2018/7/31.
//  Copyright © 2018年 Shine. All rights reserved.
//

import UIKit

class BCCommentCell: BCBaseTableViewCell {

    private lazy var iconView: UIImageView = {
        let iw = UIImageView()
        iw.contentMode = .scaleAspectFill
        iw.layer.cornerRadius = 20
        iw.layer.masksToBounds = true
        return iw
    }()
    
    lazy var nickNameLabel: UILabel = {
        let nl = UILabel()
        nl.textColor = UIColor.gray
        nl.font = UIFont.systemFont(ofSize: 13)
        return nl
    }()
    
    lazy var contentLabel: UILabel = {
        let cw = UILabel()
        cw.font = UIFont.systemFont(ofSize: 13)
        cw.numberOfLines = 0
        cw.textColor = UIColor.black
        return cw
    }()
    
    override func configUI() {
        contentView.addSubview(iconView)
        iconView.snp.makeConstraints{
            $0.left.top.equalToSuperview().offset(10)
            $0.width.height.equalTo(40)
        }
        
        contentView.addSubview(nickNameLabel)
        nickNameLabel.snp.makeConstraints {
            $0.left.equalTo(iconView.snp.right).offset(10)
            $0.top.equalTo(iconView)
            $0.right.equalToSuperview().offset(-10)
            $0.height.equalTo(15)
        }
        
        contentView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(nickNameLabel.snp.bottom).offset(10)
            $0.left.right.equalTo(nickNameLabel)
            $0.bottom.equalToSuperview().offset(-10)
        }
    }
    
    var viewModel: CommentModel? {
        didSet {
            guard let model = viewModel else { return }
            iconView.kf.setBCImage(urlString: model.face)
            nickNameLabel.text = model.nickname
            contentLabel.text = model.content_filter
        }
    }
}
