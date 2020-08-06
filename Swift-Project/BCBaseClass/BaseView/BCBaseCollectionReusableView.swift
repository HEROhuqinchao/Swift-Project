//
//  BCBaseCollectionReusableView.swift
//  BCSwiftDemo
//
//  Created by NewUser on 2018/7/6.
//  Copyright © 2018年 Shine. All rights reserved.
//

import UIKit
import Reusable

class BCBaseCollectionReusableView: UICollectionReusableView, Reusable {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func configUI() {}
}
