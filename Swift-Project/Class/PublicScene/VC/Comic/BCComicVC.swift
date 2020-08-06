//
//  BCDetailVC.swift
//  BCSwiftDemo
//
//  Created by NewUser on 2018/7/27.
//  Copyright © 2018年 Shine. All rights reserved.
//

import UIKit

@objc protocol BCComicViewScrollDelegate: class {
    func comicWillEndDragging(_ scrollView: UIScrollView)
}

class BCComicVC: BCCustomNavVC {

    private var comicid: Int = 0
    
    private lazy var mainScrollView: UIScrollView = {
        let sw = UIScrollView()
        sw.delegate = self
        return sw
    }()
    
    private lazy var detailVC: BCDetailVC = {
        let dc = BCDetailVC()
        dc.delegate = self
        return dc
    }()
    
    private lazy var chapteVC: BCChapterVC = {
        let cc = BCChapterVC()
        cc.delegate = self
        return cc
    }()
    
    private lazy var commentVC: BCCommentVC = {
        let dc = BCCommentVC()
        dc.delegate = self
        return dc
    }()
    
    private lazy var pageVC: BCPageViewController = {
        return BCPageViewController(titles: ["详情", "目录", "评论"],
                                    vcs: [detailVC, chapteVC, commentVC],
                                    pageStyle: .topTabBar)
    }()
    
    lazy var headerView: BCComicHead = {
        let view = BCComicHead(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: bcNavBarHeight + 150))
        return view
    }()
    
    private var detailStatic: DetailStaticModel?
    private var detailRealtime: DetailRealtimeModel?
    var childScrollView: UIScrollView?
    
    convenience init(comicid: Int) {
        self.init()
        self.comicid = comicid
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bcBar.bc_setBackgroundAlpha(alpha: 0)
        mainScrollView.contentOffset = CGPoint(x: 0, y: -mainScrollView.parallaxHeader.height)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.changeOrientationTo(landscapeRight: false)
        lodeComicData()
    }
    
    private func lodeComicData() {
        let group = DispatchGroup()
        
        group.enter()
        ApiLoadingProvider.request(BCAPI.detailStatic(comicid: comicid),
                                   model: DetailStaticModel.self) { [weak self] (detailStatic) in
                                   self?.detailStatic = detailStatic
                                   self?.headerView.detailStatic = detailStatic?.comic

                                    self?.detailVC.detailStatic = detailStatic
                                    self?.chapteVC.detailStatic = detailStatic
                                    self?.commentVC.detailStatic = detailStatic

                                    ApiProvider.request(BCAPI.commentList(object_id: detailStatic?.comic?.comic_id ?? 0,
                                                                         thread_id: detailStatic?.comic?.thread_id ?? 0,
                                                                         page: -1),
                                                        model: CommentListModel.self,
                                                        completion: { [weak self] (commentList) in
                                                            
                                                            self?.commentVC.commentList = commentList
                                                            group.leave()
                                    })
        }
        
        group.enter()
        ApiProvider.request(BCAPI.detailRealtime(comicid: comicid),
                            model: DetailRealtimeModel.self) { [weak self] (returnData) in
                                self?.detailRealtime = returnData
                                self?.headerView.detailRealtime = returnData?.comic
                                
                                self?.detailVC.detailRealtime = returnData
                                self?.chapteVC.detailRealtime = returnData

                                group.leave()
        }
        
        group.enter()
        ApiProvider.request(BCAPI.guessLike, model: GuessLikeModel.self) { (returnData) in
            self.detailVC.guessLike = returnData
            group.leave()
        }
        
        group.notify(queue: DispatchQueue.main) {
            self.detailVC.reloadData()
            self.chapteVC.reloadData()
            self.commentVC.reloadData()
        }
        
    }
    
    override func configUI() {
        view.addSubview(mainScrollView)
        mainScrollView.snp.makeConstraints {
            $0.edges.equalTo(self.view.usnp.edges).priority(.low)
            $0.top.equalToSuperview()
        }
        
        let contentView = UIView()
        mainScrollView.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalToSuperview().offset(-bcNavBarHeight)
        }
        
        addChild(pageVC)
        contentView.addSubview(pageVC.view)
        pageVC.view.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        mainScrollView.parallaxHeader.view = headerView
        mainScrollView.parallaxHeader.height = bcNavBarHeight + 150
        mainScrollView.parallaxHeader.minimumHeight = bcNavBarHeight
        mainScrollView.parallaxHeader.mode = .fill
    }
    
}

extension BCComicVC: UIScrollViewDelegate, BCComicViewScrollDelegate {
    
    func comicWillEndDragging(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 0 {
            mainScrollView.setContentOffset(CGPoint(x: 0,
                                                    y: -self.mainScrollView.parallaxHeader.minimumHeight),
                                            animated: true)
        } else if scrollView.contentOffset.y < 0 {
            mainScrollView.setContentOffset(CGPoint(x: 0,
                                                    y: -self.mainScrollView.parallaxHeader.height),
                                            animated: true)
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y >= -self.mainScrollView.parallaxHeader.minimumHeight {
            bcBar.bc_setBackgroundAlpha(alpha: 1)
            bcBar.bcTitle = detailStatic?.comic?.name
        } else {
            bcBar.bc_setBackgroundAlpha(alpha: 0)
            bcBar.bcTitle = ""
        }
    }
}

