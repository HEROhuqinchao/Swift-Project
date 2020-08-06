//
//  GYCommonFuction.swift
//  SwiftDemo
//
//  Created by lyons on 2019/2/1.
//  Copyright © 2019 lyons. All rights reserved.
//

import Foundation
import UIKit
//let height = UIApplication.shared.windows.first { $0.isKeyWindow }?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
let statusAndNaviH = UIApplication.shared.windows.first { $0.isKeyWindow }?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0 + 44

//获取导航栏+状态栏的高度
extension UIViewController{
    func naviAndStatusHight() -> CGFloat {
        return self.navigationController!.navigationBar.frame.size.height+(UIApplication.shared.windows.first { $0.isKeyWindow }?.windowScene?.statusBarManager?.statusBarFrame.height)!
    }
    /// 尺寸
    var statusBarH: CGFloat {
        get {
            let naviH = navigationController?.navigationBar.frame.size.height
            let statusH = UIApplication.shared.windows.first { $0.isKeyWindow }?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
            return  ((naviH == nil) ? 0:naviH!) + statusH
        }
        set(newValue) {

        }
    }
}

/// 手机号校验
///
/// - Parameter num: 手机号字符串
/// - Returns: 正确或错误
func isTelNumber(num:NSString)->Bool{
    let mobile = "^1((3[0-9]|4[57]|5[0-35-9]|7[0678]|8[0-9])\\d{8}$)"
    let CM = "(^1(3[4-9]|4[7]|5[0-27-9]|7[8]|8[2-478])\\d{8}$)|(^1705\\d{7}$)"
    let CU = "(^1(3[0-2]|4[5]|5[56]|7[6]|8[56])\\d{8}$)|(^1709\\d{7}$)"
    let CT = "(^1(33|53|77|8[019])\\d{8}$)|(^1700\\d{7}$)"
    let regextestmobile = NSPredicate(format: "SELF MATCHES %@",mobile)
    let regextestcm = NSPredicate(format: "SELF MATCHES %@",CM )
    let regextestcu = NSPredicate(format: "SELF MATCHES %@" ,CU)
    let regextestct = NSPredicate(format: "SELF MATCHES %@" ,CT)
    if ((regextestmobile.evaluate(with: num) == true) || (regextestcm.evaluate(with: num)  == true)||(regextestct.evaluate(with: num) == true) || (regextestcu.evaluate(with: num) == true)){
        return true
    }else{
        return false
    }
}

extension String{
    
    /// string转viewController
    ///
    /// - Returns: ViewController
    func stringChangeToVC() -> UIViewController?{
        //Swift中命名空间的概念
        var vc = UIViewController()
        if let nameSpage = Bundle.main.infoDictionary!["CFBundleExecutable"] as? String {
            if let childVcClass = NSClassFromString(nameSpage + "." + self) {
                if let childVcType = childVcClass as? UIViewController.Type {
                    //根据类型创建对应的对象
                    vc = childVcType.init() as UIViewController
                    return vc
                }
            }
        }
        return nil
    }
}

extension UIImage {
    /// 根据颜色生成图片
    ///
    /// - Parameter color: 颜色
    /// - Returns: 生成图片
    static func imageWithColor(color: UIColor) -> UIImage {
        let rect  = CGRect(x: 0, y: 0, width: 1.0, height: 1.0)
        // 开启位图上下文
        UIGraphicsBeginImageContext(rect.size)
        // 开启上下文
        let ref = UIGraphicsGetCurrentContext()!
        // 使用color演示填充上下文
        ref.setFillColor(color.cgColor)
        // 渲染上下文
        ref.fill(rect)
        // 从上下文中获取图片
        let image:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        // 结束上下文
        UIGraphicsEndImageContext()
        return image
    }
}
