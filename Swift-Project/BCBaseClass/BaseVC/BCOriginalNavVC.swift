//
//  BCOriginalNavVC.swift
//  BCSwiftDemo
//
//  Created by NewUser on 2018/7/2.
//  Copyright © 2018年 Shine. All rights reserved.
//

import UIKit

class BCOriginalNavVC: BCBaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        configNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
     func configNavigationBar() {
        guard let navi = navigationController else { return }
        if navi.visibleViewController == self {
            /*
             如果不设置BackgroundImage 背景图片  界面内的相对于顶部的约束就不会 自动适配到导航下方
             而是会从view顶部开始，向上被导航遮盖住
             */
            navigationController?.navigationBar.setBackgroundImage(UIImage(named: "nav_bg"), for: .default)
            navigationController?.navigationBar.shadowImage = UIImage()
            if navi.viewControllers.count > 1 {
                let leftBtn = UIButton()
                leftBtn.sizeToFit()
                leftBtn.setImage(UIImage(named: "nav_back_white"), for: .normal)
                leftBtn.addTarget(self, action: #selector(originalNavBack), for: .touchUpInside)
                navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftBtn)
            }
        }
    }
    
    @objc func originalNavBack() {
        navigationController?.popViewController(animated: true)
    }

}

extension BCOriginalNavVC {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
