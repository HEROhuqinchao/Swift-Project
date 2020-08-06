//
//  SearchVC.swift
//  BCSwiftDemo
//
//  Created by NewUser on 2018/8/9.
//  Copyright © 2018年 Shine. All rights reserved.
//

import UIKit

class SearchVC: BCCustomNavVC {
    
    lazy var searchBar: UITextField = {
        let sr = UITextField()
        sr.frame = CGRect(x: 20, y: bcTopBarHeight, width: kScreenWidth - 75, height: 30)
        sr.backgroundColor = UIColor.white
        sr.textColor = UIColor.gray
        sr.tintColor = UIColor.darkGray
        sr.font = UIFont.systemFont(ofSize: 15)
        sr.placeholder = "请输入漫画名称/作者"
        sr.layer.cornerRadius = 15
        sr.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 15))
        sr.leftViewMode = .always
        sr.clearButtonMode = .whileEditing
        sr.returnKeyType = .search
        sr.delegate = self
        return sr
    }()
    
    lazy var historyTab: UITableView = {
        let tw = UITableView(frame: CGRect.zero, style: .grouped)
        tw.delegate = self
        tw.dataSource = self
        tw.register(headerFooterViewType: BCSearchHead.self)
        tw.register(cellType: BCBaseTableViewCell.self)
        tw.register(headerFooterViewType: BCSearchFoot.self)
        return tw
    }()
    
    lazy var searchTab: UITableView = {
        let st = UITableView(frame: CGRect.zero, style: .grouped)
        st.delegate = self
        st.dataSource = self
        st.register(cellType: BCBaseTableViewCell.self)
        st.register(headerFooterViewType: BCSearchHead.self)
        return st
    }()
    
    lazy var resultTab: UITableView = {
        let rw = UITableView(frame: CGRect.zero, style: .grouped)
        rw.delegate = self
        rw.dataSource = self
        rw.register(cellType: ProductionCell.self)
        return rw
    }()
    
    private var searchHistory: [String]? = BCUserManager.shareManager.searchHistory
    
    private var currentRequest: Cancellable?
    
    private var hotItems: [SearchItemModel]?
    
    private var relative: [SearchItemModel]?
    
    private var comics: [ComicModel]?
    
    let dispose = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textObser()
    }
    
    private func textObser() {
         searchBar.rx.text.orEmpty.asObservable()
            .throttle(DispatchTimeInterval.seconds(3), scheduler: MainScheduler.instance)
                                  .distinctUntilChanged()
                                  .flatMapLatest { (quer) -> Observable<[SearchItemModel]> in
                                     if quer.isEmpty {
                                      self.loadHistory()
                                      return Observable.just([SearchItemModel]())
                                     }
                                      self.searchRelative(quer)
                                      return Observable.just(self.relative ?? [SearchItemModel]())
                                    .catchErrorJustReturn([])
                                  }.observeOn(MainScheduler.instance)
                                .subscribe(onNext: { (modelArray) in
                                       print(modelArray)
                                 }).disposed(by: dispose)
        
    }

    override func setBCNavBar() {
        super.setBCNavBar()
        bcBar.addSubview(searchBar)
        bcBar.bcLeftBtn.isHidden = true
        bcBar.bc_setRightButton(title: "取消", titleColor: UIColor.white)
        bcBar.onRightBtnClick = {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    override func configUI() {
        
        view.addSubview(historyTab)
        historyTab.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: bcNavBarHeight, left: 0, bottom: 0, right: 0))
        }

        view.addSubview(searchTab)
        searchTab.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: bcNavBarHeight, left: 0, bottom: 0, right: 0))
        }

        view.addSubview(resultTab)
        resultTab.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: bcNavBarHeight, left: 0, bottom: 0, right: 0))
        }
        
    }
    
}

extension SearchVC {
    
    private func loadHistory() {
        historyTab.isHidden = false
        searchTab.isHidden = true
        resultTab.isHidden = true
        ApiLoadingProvider.request(BCAPI.searchHot, model: HotItemsModel.self) { (returnData) in
            self.hotItems = returnData?.hotItems
            self.historyTab.reloadData()
        }
    }
    
    private func searchRelative(_ text: String)  {
        if text.count > 0 {
            historyTab.isHidden = true
            searchTab.isHidden = false
            resultTab.isHidden = true
            currentRequest?.cancel()
            currentRequest = ApiProvider.request(BCAPI.searchRelative(inputText: text), model: [SearchItemModel].self) { (returnData) in
                self.relative = returnData
                self.searchTab.reloadData()
            }
        } else {
            historyTab.isHidden = false
            searchTab.isHidden = true
            resultTab.isHidden = true
        }
    
    }
    
    private func searchResult(_ text: String) {
        if text.count > 0 {
            historyTab.isHidden = true
            searchTab.isHidden = true
            resultTab.isHidden = false
            searchBar.text = text
            ApiLoadingProvider.request(BCAPI.searchResult(argCon: 0, q: text), model: SearchResultModel.self) { (returnData) in
                self.comics = returnData?.comics
                self.resultTab.reloadData()
            }
            
            var histoary = BCUserManager.shareManager.searchHistory
            if histoary != nil {
                histoary?.remove(text)
                histoary?.insertFirst(text)
            } else {
                BCUserManager.shareManager.searchHistory = [text]
                histoary = BCUserManager.shareManager.searchHistory
            }
            searchHistory = histoary
            BCUserManager.shareManager.searchHistory = histoary
            
        } else {
            historyTab.isHidden = false
            searchTab.isHidden = true
            resultTab.isHidden = true
        }
    }
}

extension SearchVC: SearchHeadDeleagte, BCSearchFootDelegate {
    func searchTHead(_ searchTHead: BCSearchHead, moreAction button: UIButton) {
        if searchTHead.titleLabel.text == "看看你都搜过什么" {
            BCUserManager.shareManager.searchHistory?.removeAll()
            searchHistory?.removeAll()
            historyTab.reloadData()
        }else if searchTHead.titleLabel.text == "大家都在搜" {
            loadHistory()
        }
    }
    
    func searchTFoot(_ searchTFoot: BCSearchFoot, didSelectItemAt index: Int, _ model: SearchItemModel) {
        searchResult(model.name ?? "")
    }

}

extension SearchVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField.text?.count)! > 0 {
            searchResult(textField.text ?? "")
            return true
        }
        return false
    }
}

extension SearchVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == historyTab {
            return 2
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == historyTab {
            return section == 0 ? (searchHistory?.prefix(5).count ?? 0) : 0
        } else if tableView == searchTab {
            return relative?.count ?? 0
        } else {
            return comics?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == resultTab {
            return 180
        } else {
            return 44
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == historyTab {
            let  cell = tableView.dequeueReusableCell(for: indexPath, cellType: BCBaseTableViewCell.self)
            cell.textLabel?.text = searchHistory?[indexPath.row]
            cell.textLabel?.textColor = UIColor.darkGray
            cell.textLabel?.font = UIFont.systemFont(ofSize: 13)
            cell.separatorInset = .zero
            return cell
        } else if tableView == searchTab {
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: BCBaseTableViewCell.self)
            cell.textLabel?.text = relative?[indexPath.row].name
            cell.textLabel?.textColor = UIColor.darkGray
            cell.textLabel?.font = UIFont.systemFont(ofSize: 13)
            cell.separatorInset = .zero
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: ProductionCell.self)
            cell.pModel = comics?[indexPath.row]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == historyTab {
            searchResult(searchHistory?[indexPath.row] ?? "")
        }else if tableView == searchTab {
            searchResult(relative?[indexPath.row].name ?? "")
        } else if tableView == resultTab {
            guard let model = comics?[indexPath.row] else { return }
            let vc = BCComicVC(comicid: model.comicId)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == historyTab {
            return 44
        } else if tableView == searchTab {
            return relative?.count ?? 0 > 0 ? 44 : CGFloat.leastNormalMagnitude
        } else {
            return CGFloat.leastNormalMagnitude
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == historyTab {
            let head = tableView.dequeueReusableHeaderFooterView(BCSearchHead.self)
            head?.titleLabel.text = section == 0 ? "看看你都搜过什么":"大家都在搜"
            let image = section == 0 ? UIImage(named: "search_history_delete") : UIImage(named: "search_keyword_refresh")
            head?.moreBtn.setImage(image, for: .normal)
            head?.delegate = self
            return head
        } else if tableView == searchTab {
            let head = tableView.dequeueReusableHeaderFooterView(BCSearchHead.self)
            head?.titleLabel.text = "找到相关的漫画 \(relative?.count ?? 0) 本"
            head?.moreBtn.isHidden = true
            return head
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if tableView == historyTab {
            return section == 0 ? 10 : tableView.frame.height - 44
        } else {
            return CGFloat.leastNormalMagnitude
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView?  {
        if tableView == historyTab && section == 1 {
            let foot = tableView.dequeueReusableHeaderFooterView(BCSearchFoot.self)
            foot?.data = hotItems ?? []
            foot?.delegate = self
            return foot
        } else {
            return nil
        }
    }
    
}
