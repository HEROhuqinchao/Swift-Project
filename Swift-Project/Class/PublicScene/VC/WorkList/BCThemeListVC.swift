//
//  BCThemeListVC.swift
//  BCSwiftDemo
//
//  Created by NewUser on 2018/7/12.
//  Copyright © 2018年 Shine. All rights reserved.
//

import UIKit

class BCThemeListVC: BCOriginalNavVC {
    
    private var page: Int = 1
    private var argCon: Int = 0
    private var specialList: [ComicModel]?
    private let vm = ThemeVM()
    private let dispose = DisposeBag()
    
    
    lazy var themeTab: UITableView = { [weak self] in
        let tab = UITableView(frame: CGRect.zero, style: .plain)
        tab.separatorStyle = .none
        tab.rowHeight = 200
        tab.backgroundColor = UIColor.init(r: 242, g: 242, b: 242)
        tab.register(cellType: ThemeListCell.self)
        self?.bcTabView = tab
        tab.dataSource = self
        tab.delegate = self
        return tab
    }()
    
    convenience init(argCon: Int = 0) {
        self.init()
        self.argCon = argCon
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        observeChange()
        themeTab.mj_header?.beginRefreshing()
    }

    override func configUI() {
        view.addSubview(themeTab)
        themeTab.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.height.equalTo(kScreenHeight - bcNavBarHeight)
        }
    }

    override func lodeData() { themRequest(argCon, 1) }
    override func loadMoreData() {
        page = page + 1
        themRequest(argCon, page)
    }
}

extension BCThemeListVC {
    private func themRequest(_ argo: Int,
                 _ page: Int) {
        vm.comicRequest(argCon, page) { [weak self] in
            self?.themeTab.mj_header?.endRefreshing()
            self?.themeTab.mj_footer?.endRefreshing()
            if $0 {
                self?.themeTab.mj_footer?.endRefreshingWithNoMoreData()
            }
        }
    }
    
    private func observeChange() {
        vm.dataModel.asObservable()
            .subscribe(onNext: { [weak self] (model) in
                self?.specialList = model.comics
                self?.themeTab.reloadData()
            }).disposed(by: dispose)
    }
}

extension BCThemeListVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return specialList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: ThemeListCell.self)
        let model = specialList?[indexPath.row]
        cell.cellStyle = .defaultStyle
        cell.themeModel = model
        return cell
    }
    
}
