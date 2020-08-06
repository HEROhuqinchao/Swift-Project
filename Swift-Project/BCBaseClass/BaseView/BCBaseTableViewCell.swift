//
//  BCBaseTableViewCell.swift
//  BCSwiftDemo
//
//  Created by NewUser on 2018/7/12.
//  Copyright © 2018年 Shine. All rights reserved.
//

import UIKit

class BCBaseTableViewCell: UITableViewCell, Reusable {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func configUI() {}

}
