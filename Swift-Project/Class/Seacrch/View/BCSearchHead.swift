//
//  BCSearchHead.swift
//  BCSwiftDemo
//
//  Created by NewUser on 2018/8/10.
//  Copyright © 2018年 Shine. All rights reserved.
//

import UIKit

protocol SearchHeadDeleagte: class {
    func searchTHead(_ searchTHead: BCSearchHead, moreAction button: UIButton)
}

class BCSearchHead: BCBaseTableViewHeaderFooterView {

    weak var delegate: SearchHeadDeleagte?
    
    lazy var titleLabel: UILabel = {
        let tl = UILabel()
        tl.font = UIFont.systemFont(ofSize: 14)
        tl.textColor = UIColor.gray
        return tl
    }()

    lazy var moreBtn: UIButton = {
        let mn = UIButton(type: .custom)
        mn.setTitleColor(UIColor.lightGray, for: .normal)
        mn.addTarget(self, action: #selector(BCSearchHead.moreAction(_:)), for: .touchUpInside)
        return mn
    }()
    
    override func configUI() {
        contentView.backgroundColor = UIColor.white
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.top.bottom.equalToSuperview()
            $0.width.equalTo(200)
        }
        
        contentView.addSubview(moreBtn)
        moreBtn.snp.makeConstraints {
            $0.top.right.bottom.equalToSuperview()
            $0.width.equalTo(40)
        }
        
        let line = UIView()
        line.backgroundColor = UIColor.white
        contentView.addSubview(line)
        line.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
    
    @objc func moreAction( _ sender: UIButton) {
        delegate?.searchTHead(self, moreAction: sender)
    }
}
