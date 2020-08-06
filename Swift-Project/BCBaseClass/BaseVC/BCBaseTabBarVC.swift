//
//  BCBaseTabBarVC.swift
//  BCSwiftDemo
//
//  Created by NewUser on 2018/7/2.
//  Copyright © 2018年 Shine. All rights reserved.
//

import UIKit
import ESTabBarController_swift

class BCNavigationVC: UINavigationController {
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if viewControllers.count > 0 { viewController.hidesBottomBarWhenPushed = true }
        super.pushViewController(viewController, animated: animated)
    }
    
}

class BCBaseTabBarVC {
    
    static func tabbarWithNavigationStyle() -> ESTabBarController {
        //初始化tabBarController
        let tabBarController = ESTabBarController()
        tabBarController.delegate = nil
        tabBarController.title = "Irregularity"
        tabBarController.tabBar.shadowImage = UIImage(named: "transparent")
        tabBarController.tabBar.backgroundImage = UIImage(named: "background_dark")
        //首页
        let vipVC = BCChildListVC()
        
        let subscriptionVC = BCChildListVC()
        let onePageVC = BCHomeVC(titles: ["推荐",
                                          "VIP",
                                          "订阅",
                                          "排行"],
                                 vcs: [BCBoutiqueListVC(),
                                       vipVC,
                                       subscriptionVC,
                                       BCRankListVC()],
                                 pageStyle: .navgationBarSegment)
        
        let onePageNavVC = BCNavigationVC(rootViewController: onePageVC)
        // 分类
        let classVC = CateVC()
        // 书架
        let bookVC = BookVC()
        // 我的
        let mineVC = MineVC()
        
        // 这个图片的类型是纯图片的  如果包含上图下文中会识别不出来  无法显示
        onePageVC.tabBarItem = ESTabBarItem.init(BCIrregularityBasicContentView(), title: "首页", image: #imageLiteral(resourceName: "shop"), selectedImage: #imageLiteral(resourceName: "shop"))
        classVC.tabBarItem = ESTabBarItem.init(BCIrregularityBasicContentView(), title: "分类", image: #imageLiteral(resourceName: "brand"), selectedImage: #imageLiteral(resourceName: "branS"))
        bookVC.tabBarItem = ESTabBarItem.init(BCIrregularityBasicContentView(), title: "书架", image: UIImage(named: "shopCarSelect"), selectedImage: UIImage(named: "shopCarSelect"))
        mineVC.tabBarItem = ESTabBarItem.init(BCIrregularityBasicContentView(), title: "我的", image: UIImage(named: "mineSelect"), selectedImage: UIImage(named: "mineSelect"))
        
        tabBarController.viewControllers = [onePageNavVC, classVC, bookVC, mineVC]
        
        return tabBarController
    }
}
