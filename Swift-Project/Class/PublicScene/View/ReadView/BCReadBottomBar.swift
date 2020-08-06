//
//  BCReadBottomBar.swift
//  BCSwiftDemo
//
//  Created by NewUser on 2018/8/2.
//  Copyright © 2018年 Shine. All rights reserved.
//

import UIKit

class BCReadBottomBar: UIView {

    lazy var menuSlider: UISlider = {
        let ms = UISlider()
        ms.thumbTintColor = UIColor(r: 29, g: 221, b: 43)
        ms.minimumTrackTintColor = UIColor(r: 29, g: 221, b: 43)
        ms.isContinuous = false
        return ms
    }()
    
    lazy var deviceDirectionButton: UIButton = {
        let dn = UIButton(type: .system)
        dn.setImage(UIImage(named: "readerMenu_changeScreen_horizontal")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return dn
    }()
    
    lazy var lightButton: UIButton = {
        let ln = UIButton(type: .system)
        ln.setImage(UIImage(named: "readerMenu_luminance")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return ln
    }()
    
    lazy var chapterButton: UIButton = {
        let cn = UIButton(type: .system)
        cn.setImage(UIImage(named: "readerMenu_catalog")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return cn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func configUI() {
        addSubview(menuSlider)
        menuSlider.snp.makeConstraints {
            $0.left.right.top.equalToSuperview().inset(UIEdgeInsets(top: 10, left: 40, bottom: 10, right: 40))
            $0.height.equalTo(30)
        }
        
        addSubview(deviceDirectionButton)
        addSubview(lightButton)
        addSubview(chapterButton)
        // 对于SnpKit的扩展  多控件组的约束
        let buttonArray = [deviceDirectionButton,lightButton,chapterButton];
        buttonArray.snp.distributeViewsAlong(axisType: .horizontal, fixedSpacing: 60, leadSpacing: 40, tailSpacing: 40)
        buttonArray.snp.makeConstraints {
            $0.top.equalTo(menuSlider.snp.bottom).offset(10)
            $0.bottom.equalToSuperview()
        }
        
    }

}
