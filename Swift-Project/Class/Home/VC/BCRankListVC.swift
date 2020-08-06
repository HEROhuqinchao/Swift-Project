//
//  BCRankListVC.swift
//  BCSwiftDemo
//
//  Created by NewUser on 2018/7/12.
//  Copyright © 2018年 Shine. All rights reserved.
//

import UIKit

class BCRankListVC: BCBaseVC {
    
    var rankList: [RankingModel]?
    
    lazy var rankColl: UICollectionView = {[weak self] in
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: kScreenWidth, height: 150)
        let coll = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        coll.backgroundColor = UIColor(r: 242, g: 242, b: 242)
        coll.register(cellType: BCRankCell.self)
        self?.bcTabView = coll
        coll.bcFoot = BCRefreshTipKissFooter(with: "VIP用户专享\nVIP用户可以免费阅读全部漫画哦~")
        coll.delegate = self
        coll.dataSource = self
        return coll
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rankColl.mj_header?.beginRefreshing()
    }
    
    override func configUI() {
        rankColl.backgroundColor = UIColor.init(r: 242, g: 242, b: 242)
        view.addSubview(rankColl)
        rankColl.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.height.equalTo(kScreenHeight - bcNavBarHeight - bcTabBarHeight)
        }
    }
    
    override func lodeData() {
        ApiLoadingProvider.request(BCAPI.rankList, model: RankinglistModel.self) {[weak self] (resultModel) in
            guard let model = resultModel else {
                return
            }
            self?.rankList = model.rankinglist
            self?.rankColl.mj_header?.endRefreshing()
            self?.rankColl.mj_footer?.endRefreshing()
            self?.rankColl.reloadData()
        }
    }

}

extension BCRankListVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rankList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: BCRankCell.self)
        let model = rankList?[indexPath.row]
        cell.rankModel = model
        return cell
    }
    
    
}
