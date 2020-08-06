//
//  BCComicSeactionHeader.swift
//  BCSwiftDemo
//
//  Created by NewUser on 2018/7/9.
//  Copyright © 2018年 Shine. All rights reserved.
//

import UIKit

protocol BCComicSeactionHeaderDelegate: class {
    func comicBCseactionHead(_ comicCHead: BCComicSeactionHeader, moreAction button: UIButton)
}

class BCComicSeactionHeader: BCBaseCollectionReusableView {
    
    weak var delegate: BCComicSeactionHeaderDelegate?
    
    var bcModel: ComicListModel? {
        didSet {
            if let model = bcModel {
                iconImageV.kf.setBCImage(urlString: model.newTitleIconUrl)
                titleLabel.text = bcModel?.itemTitle
            }
        }
    }
    
    
    lazy var iconImageV: UIImageView = {
        let imageV = UIImageView()
        imageV.contentMode = .scaleToFill
        return imageV
    }()
    
    lazy var titleLabel: UILabel = {
        let tl = UILabel()
        tl.font = UIFont.systemFont(ofSize: 14)
        tl.textColor = .black
        return tl
    }()
    
    lazy var moreBtn: UIButton = {
        let mn = UIButton(type: .system)
        mn.setTitle("•••", for: .normal)
        mn.setTitleColor(UIColor.lightGray, for: .normal)
        mn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        mn.addTarget(self, action: #selector(moreAction), for: .touchUpInside)
        return mn
    }()
    
    override func configUI() {
        backgroundColor = UIColor.white
        addSubview(iconImageV)
        iconImageV.snp.makeConstraints {
            $0.left.equalToSuperview().offset(5)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(30)
        }
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.left.equalTo(iconImageV.snp.right).offset(5)
            $0.centerY.height.equalTo(iconImageV)
            $0.width.equalTo(200)
        }
        
        addSubview(moreBtn)
        moreBtn.snp.makeConstraints {
            $0.top.right.bottom.equalToSuperview()
            $0.width.equalTo(40)
        }
    }
    
   @objc func moreAction(_ sender: UIButton) {
        delegate?.comicBCseactionHead(self, moreAction: sender)
    }
}
