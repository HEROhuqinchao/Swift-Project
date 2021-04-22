//
//  Global.swift
//  BCSwiftDemo
//
//  Created by NewUser on 2018/7/3.
//  Copyright © 2018年 Shine. All rights reserved.
//

import Foundation
//屏幕宽高
let kScreenWidth = UIScreen.main.bounds.width
let kScreenHeight = UIScreen.main.bounds.height
//是否是 isIphoneX
let isIphoneX =  kScreenHeight == 812 ? true : false
// 导航栏和tabBar 的高度
let bcNavBarHeight: CGFloat = isIphoneX ? 88 : 64
let bcTabBarHeight: CGFloat = isIphoneX ? 83 : 49

let bcTopBarHeight: CGFloat = isIphoneX ? 44 : 20
let bcBottomBarHeight: CGFloat = isIphoneX ? 34 : 0


//当前的视图
var topVC: UIViewController? {
    var resultVC: UIViewController?
    DispatchQueue.main.async {
        resultVC = _topVC(UIApplication.shared.windows.first { $0.isKeyWindow }?.rootViewController)
        while resultVC?.presentedViewController != nil {
            resultVC = _topVC(resultVC?.presentedViewController)
        }
    }
    return resultVC
}

private  func _topVC(_ vc: UIViewController?) -> UIViewController? {
    if vc is UINavigationController {
        return _topVC((vc as? UINavigationController)?.topViewController)
    } else if vc is UITabBarController {
        return _topVC((vc as? UITabBarController)?.selectedViewController)
    } else {
        return vc
    }
}

//MARK: Kingfisher 扩展关于Kingfisher家长图片的

extension KingfisherWrapper where Base: KFCrossPlatformImageView {
    @discardableResult
    public func setBCImage(urlString: String?, placeholder: Placeholder? = UIImage(named: "normal_placeholder_h")) -> DownloadTask {
        return setImage(with: URL(string: urlString ?? ""),
                        placeholder: placeholder,
                        options:[.forceRefresh])!
    }
}

extension KingfisherWrapper where Base: UIButton {
    @discardableResult
    public func setBCImage(urlString: String?, for state: UIControl.State, placeholder: UIImage? = UIImage(named: "normal_placeholder_h")) -> DownloadTask {
        return setImage(with: URL(string: urlString ?? ""),
                        for: state,
                        placeholder: placeholder,
                        options: [.transition(.fade(0.5))])!
        
    }
}

//MARK: SnapKit
extension ConstraintView {
    
    var usnp: ConstraintBasicAttributesDSL {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.snp
        } else {
            return self.snp
        }
    }
}

