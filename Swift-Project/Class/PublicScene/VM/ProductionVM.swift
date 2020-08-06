//
//  ProductionVM.swift
//  BCSwiftDemo
//
//  Created by NewUser on 2018/7/17.
//  Copyright © 2018年 Shine. All rights reserved.
//

import Foundation

class ProductionVM {
    
    var dataModel = Variable(ComicListModel())
    
    func productionRequest(_ argCon: Int,
                           _ argName: String,
                           _ argValue: Int,
                           _ page: Int,
                           _ resultBlock: @escaping(_ isNoData: Bool)->()) {
        let target = BCAPI.comicList(argCon: argCon, argName: argName, argValue: argValue, page: page)
        ApiLoadingProvider.request(target, model: ComicListModel.self) { [weak self] (resultModel) in
            
            guard let model = resultModel else {
                return
            }
            
            if page == 1 {
                self?.dataModel.value = model
            } else {
                if let dataComics = self?.dataModel.value.comics, let comics = model.comics {
                    self?.dataModel.value.comics = dataComics + comics
                }
            }
            
            if model.hasMore {
                resultBlock(false)
            }else{
                resultBlock(true)
            }
        }
    }
    
}
