//
//  BCCustomNavVC.swift
//  BCSwiftDemo
//
//  Created by NewUser on 2018/7/2.
//  Copyright © 2018年 Shine. All rights reserved.
//

import UIKit

class BCCustomNavVC: BCBaseVC {

    lazy var bcBar = BCNavigationBar.getBCNavigationBar()

    override func viewDidLoad() {
        super.viewDidLoad()
        /*
         隐藏系统的bar 隐藏之后导航以导航栏为参照的控件的位置会发生变化  需要注意约束 不予系统的导航栏产生联系
         采用的是第三方FDFullscreenPopGesture的一个属性去隐藏 内部做过处理  可以解决从自定义的导航栏过渡到原生的界面偏移问题  以及想要的抽屉效果
         */
        self.fd_prefersNavigationBarHidden = true
        //自定义的导航
        setBCNavBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func setBCNavBar() {
        view.addSubview(bcBar)
        //设置自定义导航栏背景图片
        bcBar.bcBarBgImage = #imageLiteral(resourceName: "nav_bg")
        //设置自定义导航栏背景颜色 和背景图片只能设置一个
       // bcBar.bcBarBgColor = UIColor.white
        //设置自定义导航栏标题颜色
        bcBar.bcTitleColor = UIColor.white
        //设置自定义导航栏左右按钮字体颜色
        //  bcBar.bc_setTintColor(color: .white)
        if let vcCount = self.navigationController?.children.count, vcCount > 1 {
            bcBar.bc_setLeftButton(image: UIImage(named: "nav_back_white"))
        }
    }
    
}
