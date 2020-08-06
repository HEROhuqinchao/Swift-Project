//
//  BCRefresh.swift
//  BCSwiftDemo
//
//  Created by NewUser on 2018/6/26.
//  Copyright © 2018年 Shine. All rights reserved.
//

import UIKit
import MJRefresh

extension UIScrollView {
    var bcHead: MJRefreshHeader {
        get { return mj_header! }
        set { mj_header = newValue }
    }
    
    var bcFoot: MJRefreshFooter {
        get { return mj_footer! }
        set { mj_footer = newValue }
    }
}

class BCRefreshHeader: MJRefreshGifHeader {
    override func prepare() {
        super.prepare()
        setImages([UIImage(named: "refresh_normal")!], for: .idle)
        setImages([UIImage(named: "refresh_will_refresh")!], for: .pulling)
        setImages([UIImage(named: "refresh_loading_1")!,
                   UIImage(named: "refresh_loading_2")!,
                   UIImage(named: "refresh_loading_3")!], for: .refreshing)
        
        lastUpdatedTimeLabel?.isHidden = true
        stateLabel?.isHidden = true
    }
}

class BCRefreshAutoHeader: MJRefreshHeader {}

class BCRefreshFooter: MJRefreshBackNormalFooter {}

class BCRefreshAutoFooter: MJRefreshAutoFooter {}


class BCRefreshDiscoverFooter: MJRefreshBackGifFooter {
    
    override func prepare() {
        super.prepare()
        setImages([UIImage(named: "refresh_discover")!], for: .idle)
        stateLabel?.isHidden = true
        refreshingBlock = { self.endRefreshing() }
    }
}

class BCRefreshTipKissFooter: MJRefreshBackFooter {
    
    lazy var tipLabel: UILabel = {
        let tl = UILabel()
        tl.textAlignment = .center
        tl.textColor = UIColor.lightGray
        tl.font = UIFont.systemFont(ofSize: 14)
        tl.numberOfLines = 0
        return tl
    }()
    
    lazy var imageView: UIImageView = {
        let iw = UIImageView()
        iw.image = UIImage(named: "refresh_kiss")
        return iw
    }()
    
    override func prepare() {
        super.prepare()
     //   backgroundColor = UIColor(r: 242, g: 242, b: 242, alpha: 1)
        mj_h = 240
        addSubview(tipLabel)
        addSubview(imageView)
    }
    
    override func placeSubviews() {
        tipLabel.frame = CGRect(x: 0, y: 40, width: bounds.width, height: 60)
        imageView.frame = CGRect(x: (bounds.width - 80 ) / 2, y: 110, width: 80, height: 80)
    }
    
    convenience init(with tip: String) {
        self.init()
        refreshingBlock = { self.endRefreshing() }
        tipLabel.text = tip
    }
}

