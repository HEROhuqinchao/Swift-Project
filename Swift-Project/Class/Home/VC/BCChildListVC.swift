//
//  BCVIPListVC.swift
//  BCSwiftDemo
//
//  Created by NewUser on 2018/7/10.
//  Copyright © 2018年 Shine. All rights reserved.
//

import UIKit

enum BCHomeChildType {
    case VIP
    case Subscription // 订阅
}

class BCChildListVC: BCBaseVC {
    
    private let vm = BCChildListVM()
    private let disposeBag = DisposeBag()
    private var vipLists: [ComicListModel]?
    var vcType: BCHomeChildType = .VIP
    
    lazy var vipColl: UICollectionView = {[weak self] in
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 6
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let width = floor((kScreenWidth - 10.0) / 3.0)
        layout.itemSize = CGSize(width: width, height: 240)
        let coll = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        coll.backgroundColor = UIColor(r: 242, g: 242, b: 242)
        coll.register(cellType: BCComicCCell.self)
        coll.register(supplementaryViewType: BCComicSeactionHeader.self, ofKind: UICollectionView.elementKindSectionHeader)
        coll.register(supplementaryViewType: BCComicSeactionFoot.self, ofKind: UICollectionView.elementKindSectionFooter)
        self?.bcTabView = coll
        coll.bcFoot = BCRefreshTipKissFooter(with: "VIP用户专享\nVIP用户可以免费阅读全部漫画哦~")
        coll.delegate = self
        coll.dataSource = self
        return coll
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        observableChange()
        vipColl.mj_header?.beginRefreshing()
    }
    
    override func configUI() {
        view.addSubview(vipColl)
        vipColl.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.height.equalTo(kScreenHeight - bcNavBarHeight - bcTabBarHeight)
        }
    }
    
    override func lodeData() {
        vm.requestChildList(vcType) {[weak self] in
            self?.vipColl.mj_header?.endRefreshing()
            self?.vipColl.mj_footer?.endRefreshing()
        }
    }

}

extension BCChildListVC {
    
    fileprivate func observableChange() {
        vm.dataModel.asObservable()
            .subscribe(onNext: { [weak self] (model) in
                self?.vipLists = self?.vm.dataModel.value
                self?.vipColl.reloadData()
            }).disposed(by: disposeBag)
    }
    
}
extension BCChildListVC: UICollectionViewDataSource,
                         UICollectionViewDelegate,
                         UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return vipLists?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vipLists?[section].comics?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let comicList = vipLists?[section]
        return comicList?.itemTitle?.count ?? 0 > 0 ? CGSize(width: kScreenWidth, height: 44) : CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        let comicList = vipLists?[section]
        return comicList?.itemTitle?.count ?? 0 > 0 ? CGSize(width: kScreenWidth, height: 10) : CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, for: indexPath, viewType: BCComicSeactionHeader.self)
            let comicList = vipLists?[indexPath.section]
            headerView.bcModel = comicList
           // headerView.delegate = self
            return headerView
        }else {
            let footView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, for: indexPath, viewType: BCComicSeactionFoot.self)
            return footView
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let comicList = vipLists?[indexPath.section]
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: BCComicCCell.self)
        cell.style = .withTitle
        cell.model = comicList?.comics?[indexPath.row]
        return cell
    }
    
    
}
