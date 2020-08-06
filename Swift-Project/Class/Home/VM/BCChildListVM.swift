//
//  BCVIPListVM.swift
//  BCSwiftDemo
//
//  Created by NewUser on 2018/7/10.
//  Copyright © 2018年 Shine. All rights reserved.
//

import Foundation

class BCChildListVM {
    
    let disposeBag = DisposeBag()
    let dataModel = Variable([ComicListModel]())
    
    func requestChildList( _ type: BCHomeChildType,
                           _ resultBlock: @escaping ()->()) {
        switch type {
        case .VIP:
            ApiProvider.request(BCAPI.vipList, model: VipListModel.self) {[weak self] (resultModel) in
                guard let result = resultModel else {
                    return
                }
                self?.dataModel.value = result.newVipList ?? [ComicListModel]()
                resultBlock()
            }
        default:
            ApiProvider.request(BCAPI.subscribeList, model: SubscribeListModel.self) {[weak self] (resultModel) in
                guard let result = resultModel else {
                    return
                }
                self?.dataModel.value = result.newSubscribeList ?? [ComicListModel]()
                resultBlock()
            }
        }
        
    }
}
