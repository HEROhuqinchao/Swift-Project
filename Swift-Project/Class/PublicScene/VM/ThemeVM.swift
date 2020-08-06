//
//  ThemeVM.swift
//  BCSwiftDemo
//
//  Created by NewUser on 2018/7/12.
//  Copyright © 2018年 Shine. All rights reserved.
//

import Foundation

class ThemeVM {
    
    var dataModel = Variable(ComicListModel())
    
    func comicRequest(_ argCon: Int,
                      _ page: Int,
                      _ resultBlock: @escaping(_ isNoData: Bool)->()) {
        ApiLoadingProvider.request(BCAPI.special(argCon: argCon, page: page), model: ComicListModel.self) { [weak self] (resultModel) in
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
