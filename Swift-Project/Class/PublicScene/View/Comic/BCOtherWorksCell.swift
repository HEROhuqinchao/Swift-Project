//
//  BCOtherWorksCell.swift
//  BCSwiftDemo
//
//  Created by NewUser on 2018/7/30.
//  Copyright © 2018年 Shine. All rights reserved.
//

import UIKit

class BCOtherWorksCell: BCBaseTableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        accessoryType = .disclosureIndicator
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var model: DetailStaticModel? {
        didSet{
            guard let model = model else { return }
            textLabel?.text = "其他作品"
            detailTextLabel?.text = "\(model.otherWorks?.count ?? 0)本"
            detailTextLabel?.font = UIFont.systemFont(ofSize: 15)
            detailTextLabel?.textColor = UIColor.gray
        }
    }
}
