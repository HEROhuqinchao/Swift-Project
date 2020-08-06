//
//  BCString.swift
//  BCSwiftDemo
//
//  Created by NewUser on 2018/6/26.
//  Copyright © 2018年 Shine. All rights reserved.
//

import Foundation

extension String {
    func trim() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    /// 验证邮编号
    var isZipcode: Bool {
        let regex = "[1-9]\\d{5}(?!\\d)"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: self)
    }
    /// 验证银行卡
    var isBankCard: Bool {
        var oddSum = 0     //奇数求和
        var evenSum = 0    //偶数求和
        var allSum = 0
        
        let count = self.count
        if  count < 15 || count > 19 {
            print("银行卡号位数不对，一般15-19位，该卡号\(count)位")
            return false
        }
        let array = Array(arrayLiteral: String())
        
        for (i, value) in array.enumerated().reversed() {
            guard let t = Int(String.init(value)) else {
                print("银行卡号应该全是数组，你输入了其他字符")
                return false
            }
            let index = count - i
            if index % 2 == 0 {
                let temp = t * 2
                evenSum += temp > 9 ? temp - 9 : temp
            } else {
                oddSum += t
            }
        }
        allSum = oddSum + evenSum
        if allSum % 10 == 0 {
            print("💐、银行卡号格式正确")
            return true
        }
        print("银行卡号格式不对")
        return false
    }
    /// 精确验证身份证号
    var isIDCard: Bool {
        var msg: String
        let count = self.count
        
        if count != 18, count != 15 {
            msg = "中国公民身份证的长度应为15位或者18位，而您输入的长度为: \(self.count)位"
            print(msg)
            return false
        }
        // 地区码
        let areas = ["11", "12", "13", "14", "15", "21", "22", "23", "31", "32", "33", "34", "35", "36", "37", "41", "42", "43", "44", "45", "46", "50", "51", "52", "53", "54", "61", "62", "63", "64", "65", "71", "81", "82", "91"]
        let areaCode = String(self[ self.at(2)])
        if !areas.contains(areaCode) {
            print("不存在地区码: \(areaCode)")
            return false
        }
        var id = self
        if count == 15 {
            // 将15位转为18位
            id.insert(Character("1"), at: self.at(6))
            id.insert(Character("9"), at: id.at(7))
            id.append("1")
            print("15位: \(self), 被转为18位: \(id)")
        }
        let year = Int(id[( id.at(6)..<id.at(10))])!
        var regular = "^[1-9][0-9]{5}(19|20)[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9X|x]$"
        // 闰年
        if year % 400 == 0 || (year % 4 == 0 && year % 100 != 0) {
            regular = "^[1-9][0-9]{5}(19|20)[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9X|x]$"
        }
        let predicate = NSPredicate(format: "SELF MATCHES %@", regular)
        let isMatch = predicate.evaluate(with: id)
        if count == 15, isMatch {
            print("满足15位身份证格式")
            return true
        }
        // 18 位
        if isMatch {
            // 校验位计算，对应系数
            let conefficient = [7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2]
            var num = 0
            for i in 0..<count - 1 {
                num += Int(self[( self.at(i)..<self.at(i + 1))])! * conefficient[i]
            }
            // 结果校验码
            let checkCode = ["1", "0", "X", "9", "8", "7", "6", "5", "4", "3", "2"]
            if checkCode[num % 11] == self[( self.index(before: self.endIndex))].uppercased() {
                print("满足18位身份证格式")
                return true
            } else {
                print("校验码不对, 正常应为: \(checkCode[num % 11])")
            }
        } else {
            print("可能年月日格式不对")
        }
        return false
    }
    
    func at(_ index: String.IndexDistance) -> String.Index {
        
        return self.index(self.startIndex, offsetBy: index)
    }
    //MARK: -  正则表达式验证
    public enum ValidatedType: String {
        case Email = "^([a-z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$"
        case PhoneNumber = "^((13[0-9])|(14[5,7,9])|(15[^4,\\D])|(17[^2,^4,^9,\\D])|(18[0-9]))\\d{8}$"
    }
    
    /**
     正则验证
     - parameter type: 验证类型
     - returns:验证结果
     */
    func validateText(_ validatedType: ValidatedType) -> Bool {
        do {
            let pattern = validatedType.rawValue
            let regex: NSRegularExpression = try NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.caseInsensitive)
            let matches = regex.matches(in: self, options: NSRegularExpression.MatchingOptions.reportProgress, range: NSMakeRange(0, self.count))
            return matches.count > 0
        }
        catch {
            return false
        }
    }
    
    /**
     根据时长格式化输出
     - parameter duration: 单位(秒)
     
     - returns: 返回格式化后的时长
     */
    func getFormatterDuration(_ duration: Int) -> String {
        let hour = duration / 3600
        let minute = (duration - hour * 3600) / 60
        if hour <= 0 {
            return "\(minute)分钟"
        }
        if minute <= 0 {
            return "\(hour)小时"
        }
        return "\(hour)小时\(minute)分钟"
    }
    
    /**
     根据正则过滤公交线路名称(例子:949路(厦门北站--前埔公交场站) -> 949路)
     - returns: 过滤后的名称
     */
    func getSimpleSimpleBusLineName() -> String {
        let pattern = "\\(.*?\\)"
        let regular = try! NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        let string = regular.stringByReplacingMatches(in: self, options: .reportCompletion, range: NSMakeRange(0, String().count), withTemplate: "")
        return string
    }
    
    
    /// 获取本地化字符串
    ///
    /// - Returns: 本地化字符串
    func localized() -> String {
        return NSLocalizedString(self, comment: self)
    }
    
}

