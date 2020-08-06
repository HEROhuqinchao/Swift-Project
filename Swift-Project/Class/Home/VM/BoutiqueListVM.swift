//
//  BoutiqueListVM.swift
//  BCSwiftDemo
//
//  Created by NewUser on 2018/7/6.
//  Copyright © 2018年 Shine. All rights reserved.
//

import Foundation

class BoutiqueListVM {
    
    let disposeBag = DisposeBag()
    let dataModel = Variable(BoutiqueListModel())
    
    func requsetBoutique_list( _ sexType: Int,
                               _ resultBlock: @escaping ()->()) {
        let token = BCAPI.boutiqueList(sexType: sexType)
        ApiProvider.request(token, model: BoutiqueListModel.self) { [weak self] (returnData) in
            self?.dataModel.value = returnData ?? BoutiqueListModel()
            resultBlock()
        }
    }
    
    
}
