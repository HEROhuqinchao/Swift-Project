//
//  BoutiListBannerView.swift
//  BCSwiftDemo
//
//  Created by NewUser on 2018/7/4.
//  Copyright © 2018年 Shine. All rights reserved.
//

import UIKit
import TYCyclePagerView

class BoutiListBannerView: UIView {

    var dataArray: [GalleryItemModel]? {
        didSet {
            if let _ = dataArray {
                pagerView.reloadData()
            }
        }
    }
    
   private lazy var pagerView: TYCyclePagerView = {
        let rect = CGRect(x: 0, y: 20, width: self.bounds.width, height: self.bounds.height - 40)
        let pagerView = TYCyclePagerView(frame: rect)
        pagerView.autoScrollInterval = 5
        pagerView.dataSource = self 
        pagerView.delegate = self
        pagerView.register(UINib.init(nibName: "BoutiListBannerCell", bundle: nil), forCellWithReuseIdentifier: "BoutiListBannerCell")
        return pagerView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configUI()
    }
    
    fileprivate func configUI() {
        backgroundColor = UIColor.white
        addSubview(pagerView)
    }
}

extension BoutiListBannerView: TYCyclePagerViewDataSource, TYCyclePagerViewDelegate {
    
    func numberOfItems(in pageView: TYCyclePagerView) -> Int {
        return dataArray?.count ?? 0
    }
    
    func layout(for pageView: TYCyclePagerView) -> TYCyclePagerViewLayout {
        let layout = TYCyclePagerViewLayout()
        layout.itemSpacing = 20
        layout.itemVerticalCenter = true
        layout.layoutType = .linear
        layout.itemSize = CGSize(width: kScreenWidth - 100, height: self.bounds.height - 40)
        return layout
    }
    
    func pagerView(_ pagerView: TYCyclePagerView, cellForItemAt index: Int) -> UICollectionViewCell {
        let coll = pagerView.dequeueReusableCell(withReuseIdentifier: "BoutiListBannerCell", for: index) as! BoutiListBannerCell
        let model = dataArray?[index]
        coll.model = model
        return coll
    }
}
