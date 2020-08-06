//
//  BCReadViewVC.swift
//  BCSwiftDemo
//
//  Created by NewUser on 2018/8/2.
//  Copyright © 2018年 Shine. All rights reserved.
//

import UIKit

class BCReadViewVC: BCCustomNavVC {
    
    lazy var backScrollView: UIScrollView = {
        let sw = UIScrollView()
        sw.delegate = self
        sw.minimumZoomScale = 1.0
        sw.maximumZoomScale = 1.5
        sw.backgroundColor = UIColor.red
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        tap.numberOfTapsRequired = 1
        sw.addGestureRecognizer(tap)
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTapAction))
        doubleTap.numberOfTapsRequired = 2
        sw.addGestureRecognizer(doubleTap)
        tap.require(toFail: doubleTap)
        
        return sw
    }()
    
    lazy var collectionView: UICollectionView = {[weak self] in
        let lt = UICollectionViewFlowLayout()
        lt.sectionInset = .zero
        lt.minimumLineSpacing = 10
        lt.minimumInteritemSpacing = 10
        let cw = UICollectionView(frame: .zero, collectionViewLayout: lt)
        cw.backgroundColor = UIColor(red: 242, green: 242, blue: 242, alpha: 1)
        self?.bcTabView = cw
        cw.register(cellType: BCReadCell.self)
        cw.delegate = self
        cw.dataSource = self
        return cw
    }()
    
    lazy var topBar: BCReadTopBar = {
        let tr = BCReadTopBar()
        tr.backgroundColor = UIColor.white
        tr.backButton.addTarget(self, action: #selector(BCReadViewVC.pressBack), for: .touchUpInside)
        tr.titleLabel.text = self.detailStatic?.comic?.name
        return tr
    }()
    
    lazy var bottomBar: BCReadBottomBar = {
        let br = BCReadBottomBar()
        br.backgroundColor = UIColor.white
        br.deviceDirectionButton.addTarget(self, action: #selector(changeDeviceDirection(_:)), for: .touchUpInside)
        br.chapterButton.addTarget(self, action: #selector(changeChapter(_:)), for: .touchUpInside)
        return br
    }()
    
    private var isBarHidden: Bool = false {
        didSet {
            UIView.animate(withDuration: 0.5) {
                self.topBar.snp.updateConstraints({
                    $0.top.equalTo(self.backScrollView.snp.top).offset(self.isBarHidden ? -(44 + bcTopBarHeight + 10) : 0)
                })
                
                self.bottomBar.snp.updateConstraints({
                    $0.bottom.equalTo(self.backScrollView.snp.bottom).offset(self.isBarHidden ? 120 + bcBottomBarHeight : 0)
                })
                
                self.view.layoutIfNeeded()
            }
        }
    }
    
    private var isLandscapeRight: Bool = false {
        // 是否是 横屏状态
        didSet {
            UIApplication.changeOrientationTo(landscapeRight: isLandscapeRight)
            collectionView.reloadData()
        }
    }
    
    private var chapterList = [ChapterModel]()
    private var detailStatic: DetailStaticModel?
    private var selectIndex: Int = 0
    private var previousIndex: Int = 0
    private var nextIndex: Int = 0
    
    convenience init(detailStatic: DetailStaticModel?, selectIndex: Int) {
        self.init()
        self.detailStatic = detailStatic
        self.selectIndex = selectIndex
        self.previousIndex = selectIndex
        self.nextIndex = selectIndex + 1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bcBar.isHidden = true
        lodeData()
    }

    override func configUI() {
        view.backgroundColor = UIColor.white
        view.addSubview(backScrollView)
        backScrollView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: bcTopBarHeight + 10, left: 0, bottom: bcBottomBarHeight, right: 0))
        }
        
        backScrollView.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.height.equalTo(backScrollView)
        }
        
        view.addSubview(topBar)
        topBar.snp.makeConstraints {
            $0.top.right.left.equalTo(backScrollView)
            $0.height.equalTo(44)
        }
        
        view.addSubview(bottomBar)
        bottomBar.snp.makeConstraints {
            $0.left.right.bottom.equalTo(backScrollView)
            $0.height.equalTo(120)
        }
    }
    
    override func lodeData() {
        let previousIndex = self.previousIndex
        requestData(with: previousIndex, isPreious: true, needClear: false, finished: { [weak self]  (finish) in
            self?.previousIndex = previousIndex - 1
        })
    }
    
    override func loadMoreData() {
        let nextIndex = self.nextIndex
        requestData(with: nextIndex, isPreious: false, needClear: false, finished: { [weak self]  (finish) in
            self?.nextIndex = nextIndex + 1
        })
    }
}

extension BCReadViewVC {
    
    @objc private func tapAction() {
        isBarHidden = !isBarHidden
    }
    
    @objc private func doubleTapAction() {
        var zoomScale = backScrollView.zoomScale
        zoomScale = 2.5 - zoomScale
        let width = view.frame.width / zoomScale
        let height = view.frame.height / zoomScale
        let x = backScrollView.center.x - width/2
        let y = backScrollView.center.y - height/2
        let zoomRect = CGRect(x: x, y: y, width: width, height: height)
        backScrollView.zoom(to: zoomRect, animated: true)
    }
    
    @objc private func pressBack() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func changeDeviceDirection(_ button: UIButton) {
        isLandscapeRight = !isLandscapeRight
        if isLandscapeRight {
            button.setImage(UIImage(named: "readerMenu_changeScreen_vertical")?.withRenderingMode(.alwaysOriginal), for: .normal)
        } else {
            button.setImage(UIImage(named: "readerMenu_changeScreen_horizontal")?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
    }
    
    @objc private func changeChapter(_ button: UIButton) {
    }
    
    private func requestData(with index: Int, isPreious: Bool, needClear: Bool, finished: ((_ finished: Bool) -> Void)? = nil) {
        guard let detailStatic = detailStatic else { return }
        
        if index <= -1 {
            collectionView.mj_header?.endRefreshing()
            BCNoticeBar(config: BCNoticeBarConfig(title: "亲,这已经是第一页了", animationType: .top)).show(duration: 2)
        } else if index >= detailStatic.chapter_list?.count ?? 0 {
            collectionView.mj_footer?.endRefreshing()
            BCNoticeBar(config: BCNoticeBarConfig(title: "亲,已经木有了", animationType: .bottom)).show(duration: 2)
        } else {
            guard let chapterId = detailStatic.chapter_list?[index].chapter_id else { return }
            ApiLoadingProvider.request(BCAPI.chapter(chapter_id: chapterId), model: ChapterModel.self) { (returnData) in
                
                self.collectionView.mj_header?.endRefreshing()
                self.collectionView.mj_footer?.endRefreshing()
                
                guard let chapter = returnData else { return }
                if needClear { self.chapterList.removeAll() }
                if isPreious {
                    self.chapterList.insert(chapter, at: 0)
                } else {
                    self.chapterList.append(chapter)
                }
                self.collectionView.reloadData()
                guard let finished = finished else { return }
                finished(true)
            }
        }
    }
}

extension BCReadViewVC: UIScrollViewDelegate {
    
    ///返回被缩放的视图
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        if scrollView == backScrollView {
            return collectionView
        } else {
            return nil
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if isBarHidden == false { isBarHidden = true }
    }
     //只要缩放就会去调用
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        if scrollView == backScrollView {
            scrollView.contentSize = CGSize(width: scrollView.frame.width * scrollView.zoomScale, height: scrollView.frame.height)
        }
    }
}

extension BCReadViewVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return chapterList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return chapterList[section].image_list?.count ?? 0

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let image = chapterList[indexPath.section].image_list?[indexPath.row] else { return CGSize.zero }
        let width = backScrollView.frame.width
        let height = floor(width/CGFloat(image.width) * CGFloat(image.height))
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: BCReadCell.self)
        cell.model = chapterList[indexPath.section].image_list?[indexPath.row]
        return cell
    }
}
