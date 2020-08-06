//
//  BCProductionVC.swift
//  BCSwiftDemo
//
//  Created by NewUser on 2018/7/12.
//  Copyright © 2018年 Shine. All rights reserved.
//

import UIKit

class BCProductionVC: BCCustomNavVC {
    
    private var argCon: Int = 0
    private var argName: String?
    private var argValue: Int = 0
    private var page: Int = 1
    
    private var proList: [ComicModel]?
    private var spinnerName: String?
    var comicType = UComicType.none
    
    let vm = ProductionVM()
    private let dispose = DisposeBag()

    private lazy var proTabView: UITableView = { [weak self] in
        let tab = UITableView(frame: CGRect.zero, style: .plain)
        tab.separatorStyle = .none
        if comicType == .update {
            tab.register(cellType: ThemeListCell.self)
            tab.rowHeight = 170
        } else {
            tab.register(cellType: ProductionCell.self)
            tab.rowHeight = 180
        }
        tab.backgroundColor = UIColor.init(r: 242, g: 242, b: 242)
        self?.bcTabView = tab
        tab.dataSource = self
        tab.delegate = self
        return tab
    }()

    convenience init(argCon: Int = 0, argName: String?, argValue: Int = 0) {
        self.init()
        self.argCon = argCon
        self.argName = argName
        self.argValue = argValue
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        proTabView.mj_header?.beginRefreshing()
        observeChange()
    }

    override func configUI() {
        view.addSubview(proTabView)
        proTabView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview().inset(UIEdgeInsets(top: bcNavBarHeight, left: 0, bottom: 0, right: 0))
            $0.height.equalTo(kScreenHeight - bcNavBarHeight)
        }
    }
    
    override func lodeData() {
        page = 1
        request()
    }
    
    override func loadMoreData() {
        page = page + 1
        request()
    }
}

extension BCProductionVC {
    
    private func request() {
        vm.productionRequest(argCon, argName ?? "", argValue, page) { [weak self] in
            self?.proTabView.mj_header?.endRefreshing()
            self?.proTabView.mj_footer?.endRefreshing()
            if $0 {
                self?.proTabView.mj_footer?.endRefreshingWithNoMoreData()
            }
        }
    }
    
    private func observeChange() {
        vm.dataModel.asObservable()
            .subscribe(onNext: { [weak self] (model) in
                self?.spinnerName = model.defaultParameters?.defaultConTagType
                self?.proList = model.comics
                self?.proTabView.reloadData()
            }).disposed(by: dispose)
    }
    
}

extension BCProductionVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return proList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if comicType == .update {
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: ThemeListCell.self)
            let model = proList?[indexPath.row]
            cell.cellStyle = .noTitleStyle
            cell.themeModel = model
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: ProductionCell.self)
            let model = proList?[indexPath.row]
            cell.spinnerName = spinnerName
            cell.bcIndexPath = indexPath
            cell.pModel = model
            return cell
        }
        
    }
    
    
}
