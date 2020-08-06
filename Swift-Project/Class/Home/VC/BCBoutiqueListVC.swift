//
//  BCBoutiqueListVC.swift
//  BCSwiftDemo
//
//  Created by NewUser on 2018/7/4.
//  Copyright © 2018年 Shine. All rights reserved.
//

import UIKit

class BCBoutiqueListVC: BCBaseVC {

   private let vm = BoutiqueListVM()
   private let disposeBag = DisposeBag()
   private var galleryItems = [GalleryItemModel]()
   private var TextItems = [TextItemModel]()
   private var comicLists = [ComicListModel]()
   private var sexType = Variable(1)
    
   private lazy var bannerView: BoutiListBannerView = {
        let view = BoutiListBannerView(frame: CGRect.zero)
        return view
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 6
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let coll = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        coll.backgroundColor = UIColor(r: 242, g: 242, b: 242)
        coll.contentInset = UIEdgeInsets(top: kScreenWidth * 0.467, left: 0, bottom: 0, right: 0)
        coll.register(cellType: BCComicCCell.self)
        coll.register(cellType: BCBoardCCell.self)
        coll.register(supplementaryViewType: BCComicSeactionHeader.self, ofKind: UICollectionView.elementKindSectionHeader)
        coll.register(supplementaryViewType: BCComicSeactionFoot.self, ofKind: UICollectionView.elementKindSectionFooter)
        bcTabView = coll
        coll.mj_footer = BCRefreshDiscoverFooter()
        coll.delegate = self
        coll.dataSource = self
        return coll
    }()
    
    lazy var sexBtn: UIButton = {
        let btn = UIButton()
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.setImage(#imageLiteral(resourceName: "gender_male"), for: .normal)
        btn.addTarget(self, action: #selector(sexBtnClick(_:)), for: .touchUpInside)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.bcHead.beginRefreshing()
        observableChange()
    }
    
    override func configUI() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.height.equalTo(kScreenHeight - bcNavBarHeight - bcTabBarHeight)
        }

        view.addSubview(bannerView)
        bannerView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.height.equalTo(collectionView.contentInset.top)
        }
        
        view.addSubview(sexBtn)
        sexBtn.snp.makeConstraints {
            $0.width.height.equalTo(60)
            $0.bottom.equalToSuperview().offset(-(20.0 + bcTabBarHeight))
            $0.right.equalToSuperview()
        }
        
    }
    
    override func lodeData() {
        vm.requsetBoutique_list(sexType.value) {
            self.collectionView.bcHead.endRefreshing()
        }
    }
    
}

extension BCBoutiqueListVC {
    
    fileprivate func observableChange() {
        vm.dataModel.asObservable()
            .subscribe(onNext: { [weak self] (model) in
                self?.bannerView.dataArray = model.galleryItems
                self?.TextItems = model.textItems ?? []
                self?.comicLists = model.comicLists ?? []
                self?.collectionView.reloadData()
            }).disposed(by: disposeBag)
        // 性别的检测
        sexType.asObservable()
            .subscribe(onNext: { [weak self] (model) in
                let image = self?.sexType.value == 1 ? #imageLiteral(resourceName: "gender_male") : #imageLiteral(resourceName: "gender_female")
                self?.sexBtn.setImage(image, for: .normal)
                self?.lodeData()
            }).disposed(by: disposeBag)
        
    }
    
    @objc fileprivate func sexBtnClick(_ sender: UIButton) {
        sexType.value = 3 - sexType.value
        BCUserManager.shareManager.sexType = sexType.value
    }
    
}

extension BCBoutiqueListVC: BCComicSeactionHeaderDelegate {
    
    func comicBCseactionHead(_ comicCHead: BCComicSeactionHeader, moreAction button: UIButton) {
        guard let model = comicCHead.bcModel else {
            return
        }
        switch model.comicType {
        case .thematic:
            let vc = BCPageViewController(titles: ["动漫",
                                                   "次元"],
                                          vcs: [BCThemeListVC(argCon: 2),
                                                BCThemeListVC(argCon: 4)],
                                          pageStyle: .navgationBarSegment)
            self.navigationController?.pushViewController(vc, animated: true)
        case .animation:
            print("web")
            let vc = BCBaseWebVC(url: "http://m.u17.com/wap/cartoon/list")
            vc.title = "动画"
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            let vc = BCProductionVC(argCon: model.argCon, argName: model.argName, argValue: model.argValue)
            vc.bcBar.bcTitle = model.itemTitle
            vc.comicType = model.comicType
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

}

extension BCBoutiqueListVC: UICollectionViewDataSource,
                            UICollectionViewDelegate,
                            UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return comicLists.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let comicList = comicLists[section]
        // 取array对象的最多前4位
        return comicList.comics?.prefix(4).count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let comicList = comicLists[indexPath.section]
        switch comicList.comicType {
        case .billboard:
            let width = floor((kScreenWidth - 15.0) / 4.0)
            return CGSize(width: width, height: 80)
        case .thematic:
            let width = floor((kScreenWidth - 5.0) / 2.0)
            return CGSize(width: width, height: 120)
        default:
            let count = comicList.comics?.prefix(4).count ?? 0
            let warp = count % 2 + 2
            let width = floor((kScreenWidth - CGFloat(warp - 1) * 5.0) / CGFloat(warp))
            return CGSize(width: width, height: CGFloat(warp * 80))
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let comicList = comicLists[section]
        return comicList.itemTitle?.count ?? 0 > 0 ? CGSize(width: kScreenWidth, height: 44) : CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        let comicList = comicLists[section]
        return comicList.itemTitle?.count ?? 0 > 0 ? CGSize(width: kScreenWidth, height: 10) : CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, for: indexPath, viewType: BCComicSeactionHeader.self)
            let comicList = comicLists[indexPath.section]
            headerView.bcModel = comicList
            headerView.delegate = self
            return headerView
        }else {
            let footView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, for: indexPath, viewType: BCComicSeactionFoot.self)
            return footView
        }
    }
    
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let comicList = comicLists[indexPath.section]
        switch comicList.comicType {
        case .billboard:
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: BCBoardCCell.self)
            cell.model = comicList.comics?[indexPath.row]
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: BCComicCCell.self)
            if comicList.comicType == .thematic {
                cell.style = .none
            } else {
                cell.style = .withTitieAndDesc
            }
            cell.model = comicList.comics?[indexPath.row]
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let comicList = comicLists[indexPath.section]
        guard let item = comicList.comics?[indexPath.row] else { return }
        switch comicList.comicType {
        case .billboard:
            let vc = BCProductionVC(argCon: item.argCon, argName: item.argName, argValue: item.argValue)
            vc.bcBar.bcTitle = item.itemTitle
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            if item.linkType == 2 {
//                guard let url = item.ext?.compactMap({ return $0.key == "url" ? $0.val : nil }).joined() else { return }
//                let vc = BCBaseWebVC(url: url)
//                navigationController?.pushViewController(vc, animated: true)
            } else {
                let vc = BCComicVC(comicid: item.comicId)
                navigationController?.pushViewController(vc, animated: true)
            }
        }
        
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        UIView.animate(withDuration: 0.5, animations: {
            self.sexBtn.transform = CGAffineTransform(translationX: 50, y: 0)
        })
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // 在非常缓慢的拖动的时候直到界面滑动停止拖动 松手后不会走减速的方法
        UIView.animate(withDuration: 0.5) {
            // 针对视图的原定最初位置的中心点为起始参照进行相应操作的，在结束之后对设置量进行的还原操作
            self.sexBtn.transform = CGAffineTransform.identity
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        //只有在不在拖动 并且没有在减速状态下才调用  因为非常缓慢的拖动的时候直到界面滑动停止拖动不会走减速的方法
        if !decelerate {
            UIView.animate(withDuration: 0.5) {
                // 针对视图的原定最初位置的中心点为起始参照进行相应操作的，在结束之后对设置量进行的还原操作
                self.sexBtn.transform = CGAffineTransform.identity
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == collectionView {
            /*
             初始化后scrollView.contentInset不会再随着contentOffset的改变而变化 是固定值
             但是初始化的scrollView.contentInset 会决定 contentOffset的初始值
             界面向上偏移是 正（+）
             界面向下偏移是 负（—）
             */
            bannerView.snp.updateConstraints{ $0.top.equalToSuperview().offset(min(0, -(scrollView.contentOffset.y + scrollView.contentInset.top))) }
        }
    }
}
