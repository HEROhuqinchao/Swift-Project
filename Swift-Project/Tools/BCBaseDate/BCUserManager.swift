//
//  BCUserManager.swift
//  BCSwiftDemo
//
//  Created by NewUser on 2018/6/26.
//  Copyright © 2018年 Shine. All rights reserved.
//

import UIKit

class BCUserManager: NSObject {
    
    static let shareManager = BCUserManager()
    
    var user_id: String? {
        set(newValue) {
            UserDefaults.standard.set(newValue, forKey: "user_id")
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.object(forKey: "user_id") as? String
        }
    }
    
    var user_phone: String? {
        set(newValue) {
            UserDefaults.standard.set(newValue, forKey: "user_phone")
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.object(forKey: "user_phone") as? String
        }
    }
    
    var  user_name: String? {
        set(newValue) {
            UserDefaults.standard.set(newValue, forKey: "user_name")
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.object(forKey: "user_name") as? String
        }
    }
    
    var user_icon: String? {
        set(newValue) {
            UserDefaults.standard.set(newValue, forKey: "user_icon")
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.object(forKey: "user_icon") as? String
        }
    }
    // 0普通用户 1,2：商家用户）
    var type: String? {
        set(newValue) {
            UserDefaults.standard.set(newValue, forKey: "type")
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.object(forKey: "type") as? String
        }
    }
    
    var sex: String? {
        set(newValue) {
            UserDefaults.standard.set(newValue, forKey: "sex")
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.object(forKey: "sex") as? String
        }
    }
    
    
    var user_birthday: String? {
        set(newValue) {
            UserDefaults.standard.set(newValue, forKey: "user_birthday")
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.object(forKey: "user_birthday") as? String
        }
    }
    
    var sexType: Int? {
        set(newValue) {
            UserDefaults.standard.set(newValue, forKey: "sexType")
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.integer(forKey: "sexType")
        }
    }
    
    var searchHistory: [String]? {
        set(newValue) {
            UserDefaults.standard.set(newValue, forKey: "searchHistory")
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.object(forKey: "searchHistory") as? [String]
        }
    }
    
}

