//
//  BCMoyaHandyEx.swift
//  BCSwiftDemo
//
//  Created by NewUser on 2018/6/26.
//  Copyright © 2018年 Shine. All rights reserved.
//

import Foundation
import Moya
import HandyJSON

struct ReturnData<T: HandyJSON>: HandyJSON {
    var message:String?
    var returnData: T?
    var stateCode: Int = 0
}

struct ResponseData<T: HandyJSON>: HandyJSON {
    var code: Int = 0
    var data: ReturnData<T>?
}

extension ObservableType where Element == Response {
    public func mapModel<T: HandyJSON>(_ type: T.Type) throws -> Observable<T> {
               return flatMap { response -> Observable<T> in
            return Observable.just(response.mapModelObser(T.self))
        }
    }
}

extension Response {
    
    func mapModelObser<T: HandyJSON>(_ type: T.Type) -> T {
        let jsonString = String(data: data, encoding: .utf8)
        guard let mode = JSONDeserializer<T>.deserializeFrom(json: jsonString) else {
            fatalError() }
        return mode
    }
    
    func mapModel<T: HandyJSON>(_ type: T.Type) throws -> T {
        let jsonString = String(data: data, encoding: .utf8)
        guard let mode = JSONDeserializer<T>.deserializeFrom(json: jsonString) else { throw MoyaError.jsonMapping(self) }
        return mode
    }
    
}

extension MoyaProvider {
    
    @discardableResult
    open func request<T: HandyJSON>(_ target: Target,
                                    model: T.Type,
                                    completion: ((_ returnData: T?) -> Void)?) -> Cancellable? {
        
        return request(target, completion: { (result) in
            guard let completion = completion else { return }
            guard let returnData = try? result.value?.mapModel(ResponseData<T>.self) else {
                completion(nil)
                return
            }
            completion(returnData.data?.returnData)
        })
    }
    
}

