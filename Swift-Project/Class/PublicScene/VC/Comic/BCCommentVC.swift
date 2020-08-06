//
//  BCCommentVC.swift
//  BCSwiftDemo
//
//  Created by NewUser on 2018/7/31.
//  Copyright © 2018年 Shine. All rights reserved.
//

import UIKit

class BCCommentVC: BCBaseVC {

    var detailStatic: DetailStaticModel?
    var commentList: CommentListModel?
    
    weak var delegate: BCComicViewScrollDelegate?
    
    private lazy var tableView: UITableView = {
        let tw = UITableView(frame: .zero, style: .plain)
        tw.rowHeight = UITableView.automaticDimension
        tw.register(cellType: BCCommentCell.self)
        tw.delegate = self
        tw.dataSource = self
        tw.bcFoot = BCRefreshFooter(refreshingBlock: { [weak self] in self?.loadMoreData() })
        return tw
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func reloadData() {
        tableView.reloadData()
    }
    
    override func loadMoreData() {
        ApiProvider.request(BCAPI.commentList(object_id: detailStatic?.comic?.comic_id ?? 0,
                                             thread_id: detailStatic?.comic?.thread_id ?? 0,
                                             page: commentList?.serverNextPage ?? 0),
                            model: CommentListModel.self) { (returnData) in
                                if returnData?.hasMore == true {
                                    self.tableView.mj_footer?.endRefreshing()
                                } else {
                                    self.tableView.mj_footer?.endRefreshingWithNoMoreData()
                                }
                                
                                if let list = self.commentList?.commentList, let returnList = returnData?.commentList {
                                    self.commentList?.commentList = list + returnList
                                }
                                self.tableView.reloadData()
        }
    }
    
    override func configUI() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {$0.edges.equalTo(self.view.usnp.edges) }
    }
}

extension BCCommentVC: UITableViewDataSource, UITableViewDelegate {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        delegate?.comicWillEndDragging(scrollView)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentList?.commentList?.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: BCCommentCell.self)
        cell.viewModel = commentList?.commentList?[indexPath.row]
        return cell
    }
}
