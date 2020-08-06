//
//  BCBaseHttpManager.swift
//  BCSwiftDemo
//
//  Created by NewUser on 2018/6/26.
//  Copyright © 2018年 Shine. All rights reserved.
//

import UIKit

//网络请求类型
enum HttpType {
    case Get
    case Post
}

class BCBaseHttpManager: NSObject {
    
    typealias succeedCallBack = (_ result : Any) -> ()
    typealias failedCallBack = (_ result : Error?) -> ()
    
    static let share = BCBaseHttpManager()
    //MARK:-网络请求管理
    fileprivate var requestCacheArr = [DataRequest]()
    
    /*
     带有请求头的基础请求
     1.请求类型
     2.请求的url
     3.请求的参数
     4.请求头
     5.请求的返回
     */
    func requestHeaderData(_ type : HttpType, urlString : String, parameters : [String : Any]? = nil , header : [String : String]? = nil, finishedCallBack : @escaping succeedCallBack , failedCallBack :@escaping failedCallBack) {
        
        
        // 获取请求类型
        let httpType  = type == .Get ? HTTPMethod.get : HTTPMethod.post
        //获取请求URL
        let url =  urlString
        let headers = HTTPHeaders.init(header!)
        
        //发送网络请求
        let dataRequest = AF.request(url, method: httpType, parameters: parameters , headers: headers).responseJSON { (response) in
            //获取结果
            guard let result = response.value else {
                
                failedCallBack(response.error)
                
                return
            }
            
            finishedCallBack(result)
        }
        
        //记录网络请求
        self.requestCacheArr.append(dataRequest)
        
    }
    /*
     带有请求头的基础请求
     1.请求类型
     2.请求的url
     3.请求的参数
     5.请求的返回
     */
    func requestHYHeaderData(_ type : HttpType, urlString : String, parameters : [String : Any]? = nil ,finishedCallBack : @escaping succeedCallBack , failedCallBack :@escaping failedCallBack) {
        
        
        // 获取请求类型
        let httpType  = type == .Get ? HTTPMethod.get : HTTPMethod.post
        //获取请求URL
        let url =  urlString
        //设置 heander
        let Authorization = ""
        let header = HTTPHeaders.init(["Authorization":Authorization])

        //发送网络请求
        let dataRequest =  AF.request(url, method: httpType, parameters: parameters , headers: header).responseJSON { (response) in
            //获取结果
            guard let result = response.value else {
                
                failedCallBack(response.error)
                
                return
            }
            finishedCallBack(result)
        }
        
        //记录网络请求
        self.requestCacheArr.append(dataRequest)
    }
    
    /*
     基础请求
     1.请求类型
     2.请求的url
     3.请求的参数
     4.请求头
     5.请求的返回
     */
    func requestData(_ type : HttpType, urlString : String, parameters : [String : Any]? = nil , finishedCallBack : @escaping succeedCallBack , failedCallBack :@escaping failedCallBack) {
        
        
        // 获取请求类型
        let httpType  = type == .Get ? HTTPMethod.get : HTTPMethod.post
        //获取请求URL
        let url =  urlString
        //发送网络请求
        let dataRequest =   AF.request(url, method: httpType, parameters: parameters).responseJSON { (response) in
            //获取结果
            guard let result = response.value else {

                failedCallBack(response.error)

                return
            }
            finishedCallBack(result)
        }
        
        
        //记录网络请求
        self.requestCacheArr.append(dataRequest)
    }
    
    
    // 移除网络请求
    func cancleBCRequest()  {
        for task in requestCacheArr{
            task.cancel()
        }
        requestCacheArr.removeAll()
    }
    
}
