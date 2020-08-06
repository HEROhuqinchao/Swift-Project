//
//  ProductionCell.swift
//  BCSwiftDemo
//
//  Created by NewUser on 2018/7/15.
//  Copyright © 2018年 Shine. All rights reserved.
//

import UIKit

class ProductionCell: BCBaseTableViewCell {
    
    var spinnerName: String?

    var pModel: ComicModel? {
        didSet {
            guard let model = pModel else { return }
            iconImageV.kf.setBCImage(urlString: model.cover, placeholder: #imageLiteral(resourceName: "normal_placeholder_h"))
            titleLabel.text = model.name
            let typeStr = model.tags?.joined(separator: " ") ?? ""
            let author = model.author ?? ""
            subTitleLabel.text = typeStr + author
            descLabel.text = model.description
            
            if spinnerName == "更新时间" {
                let comicDate = Date().timeIntervalSince(Date(timeIntervalSince1970: TimeInterval(model.conTag)))
                var tagString = ""
                if comicDate < 60 {
                    tagString = "\(Int(comicDate))秒前"
                } else if comicDate < 3600 {
                    tagString = "\(Int(comicDate / 60))分前"
                } else if comicDate < 86400 {
                    tagString = "\(Int(comicDate / 3600))小时前"
                } else if comicDate < 31536000{
                    tagString = "\(Int(comicDate / 86400))天前"
                } else {
                    tagString = "\(Int(comicDate / 31536000))年前"
                }
                tagLabel.text = "\(spinnerName!) \(tagString)"
                orderImageV.isHidden = true
            } else {
                var tagString = ""
                if model.conTag > 100000000 {
                    tagString = String(format: "%.1f亿", Double(model.conTag) / 100000000)
                } else if model.conTag > 10000 {
                    tagString = String(format: "%.1f万", Double(model.conTag) / 10000)
                } else {
                    tagString = "\(model.conTag)"
                }
                if tagString != "0" { tagLabel.text = "\(spinnerName ?? "总点击") \(tagString)" }
                orderImageV.isHidden = false
            }
        }
    }
    
    var bcIndexPath: IndexPath? {
        didSet {
            guard let indexPath = bcIndexPath else { return }
            if indexPath.row == 0 { orderImageV.image = #imageLiteral(resourceName: "rank_frist") }
            else if indexPath.row == 1 { orderImageV.image = #imageLiteral(resourceName: "rank_second") }
            else if indexPath.row == 2 { orderImageV.image = #imageLiteral(resourceName: "rank_third") }
            else { orderImageV.image = nil }
        }
    }
    

    private lazy var iconImageV: UIImageView = {
        let ig = UIImageView()
       // ig.contentMode = .scaleAspectFill
        return ig
    }()
    
    private lazy var titleLabel: UILabel = {
        let tl = UILabel()
        tl.textColor = UIColor.black
        return tl
    }()
    
    private lazy var subTitleLabel: UILabel = {
        let sl = UILabel()
        sl.textColor = UIColor.gray
        sl.font = UIFont.systemFont(ofSize: 14)
        return sl
    }()
    
    private lazy var descLabel: UILabel = {
        let dl = UILabel()
        dl.textColor = UIColor.gray
        dl.numberOfLines = 3
        dl.font = UIFont.systemFont(ofSize: 14)
        return dl
    }()
    
    private lazy var tagLabel: UILabel = {
        let tl = UILabel()
        tl.textColor = UIColor.orange
        tl.font = UIFont.systemFont(ofSize: 14)
        return tl
    }()
    
    private lazy var orderImageV: UIImageView = {
        let ow = UIImageView()
        ow.contentMode = .scaleAspectFit
        return ow
    }()
    

    
    override func configUI() {
        addSubview(iconImageV)
        iconImageV.snp.makeConstraints {
            $0.top.bottom.left.equalToSuperview().inset(UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 0))
            $0.width.equalTo(100)
        }
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.left.equalTo(iconImageV.snp.right).offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalTo(iconImageV.snp.top)
            $0.height.equalTo(30)
        }
        
        addSubview(subTitleLabel)
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(5)
            $0.left.equalTo(titleLabel.snp.left)
            $0.right.equalToSuperview().offset(-10)
            $0.height.equalTo(20)
        }
        
        addSubview(descLabel)
        descLabel.snp.makeConstraints {
            $0.left.equalTo(titleLabel.snp.left)
            $0.right.equalToSuperview().offset(-10)
            $0.height.equalTo(60)
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(5)
        }
        
        addSubview(orderImageV)
        orderImageV.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-10)
            $0.bottom.equalTo(iconImageV.snp.bottom)
            $0.height.width.equalTo(30)
        }
        
        addSubview(tagLabel)
        tagLabel.snp.makeConstraints {
            $0.bottom.equalTo(iconImageV.snp.bottom)
            $0.left.equalTo(iconImageV.snp.right).offset(10)
            $0.right.equalTo(orderImageV.snp.left).offset(-10)
            $0.height.equalTo(20)
        }
        
    }

}
