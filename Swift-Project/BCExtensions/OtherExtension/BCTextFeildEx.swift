//
//  BCTextFeildEx.swift
//  BCSwiftDemo
//
//  Created by NewUser on 2018/6/26.
//  Copyright © 2018年 Shine. All rights reserved.
//

import Foundation

private var key: Void?
extension UITextField {    
    // runtime 为系统的类添加属性
    var bcTextIndex: IndexPath? {
        get {
            return objc_getAssociatedObject(self, &key) as? IndexPath
        }
        set(newValue) {
            objc_setAssociatedObject(self, &key, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
}

