//
//  BCUIStoryboard.swift
//  BCSwiftDemo
//
//  Created by NewUser on 2018/6/26.
//  Copyright © 2018年 Shine. All rights reserved.
//

import Foundation

enum BCStoryboard : String {
    //MARK: 根据storyboard的名称补充
    case Main
}

extension UIViewController {
    var className:String {
        return "\(String(describing: object_getClass(self)))"
    }
}

extension UIStoryboard{
    
    class func initialViewControllerFromStoryboard(_ storyBoard: BCStoryboard) -> AnyObject {
        return UIStoryboard.init(name: storyBoard.rawValue, bundle: nil).instantiateInitialViewController()!
    }
    
    class func viewController<T: UIViewController>(from storyBoard: BCStoryboard, viewControllerClass: T.Type) -> T {
        let identifier = String(describing: viewControllerClass)
        return UIStoryboard.init(name: storyBoard.rawValue, bundle: nil).instantiateViewController(withIdentifier: identifier) as! T
    }
}

