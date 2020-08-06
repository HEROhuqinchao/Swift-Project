//
//  ThemeListCell.swift
//  BCSwiftDemo
//
//  Created by NewUser on 2018/7/12.
//  Copyright © 2018年 Shine. All rights reserved.
//

import UIKit

enum ThemeListCellStyle {
    case defaultStyle  //默认的  有title
    case noTitleStyle  //无title
}

class ThemeListCell: BCBaseTableViewCell {
   
    var cellStyle = ThemeListCellStyle.defaultStyle {
        didSet {
            updateUI(cellStyle)
        }
    }
    
    var themeModel: ComicModel? {
        didSet {
            guard let model = themeModel else { return }
            coverImageV.kf.setBCImage(urlString: model.cover)
            if cellStyle == .defaultStyle {
                themeTitle.text = model.title
                tipLabel.text = "    \(model.subTitle ?? "")"
            } else {
                tipLabel.text = "   \(model.description ?? "")"
            }
        }
    }
    
    private lazy var themeTitle: UILabel = {
        let lb = UILabel()
        lb.textColor = UIColor.black
        lb.font = UIFont.systemFont(ofSize: 14)
        return lb
    }()
    
    private lazy var coverImageV: UIImageView = {
        let imageV = UIImageView()
        imageV.layer.cornerRadius = 5
        imageV.layer.masksToBounds = true
        return imageV
    }()
    
    lazy var tipLabel: UILabel = {
        let tl = UILabel()
        tl.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        tl.textColor = UIColor.white
        tl.font = UIFont.systemFont(ofSize: 9)
        return tl
    }()
    
    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(r: 242, g: 242, b: 242, a: 1)
        return view
    }()
    
    fileprivate func updateUI(_ style: ThemeListCellStyle) {
        addSubview(coverImageV)
        coverImageV.snp.makeConstraints {
            $0.right.left.bottom.equalToSuperview().inset(UIEdgeInsets(top: 10, left: 10, bottom: 20, right: 10))
            $0.height.equalTo(140);
        }
        
        if style == .defaultStyle {
            addSubview(themeTitle)
            themeTitle.snp.makeConstraints {
                $0.height.equalTo(40)
                $0.bottom.equalTo(coverImageV.snp.top)
                $0.left.right.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
            }
        }
        
        coverImageV.addSubview(tipLabel)
        tipLabel.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(20)
        }
        
        addSubview(lineView)
        lineView.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(10)
        }
    }
    
}
