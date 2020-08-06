//
//  BCGuessLikeCell.swift
//  BCSwiftDemo
//
//  Created by NewUser on 2018/7/30.
//  Copyright © 2018年 Shine. All rights reserved.
//

import UIKit

typealias BCGuessLikeCellDidSelectClosure = ( _ model: ComicModel) -> ()

class BCGuessLikeCell: BCBaseTableViewCell {
    
    var didSelectClosure: BCGuessLikeCellDidSelectClosure?
    
    
    var model: GuessLikeModel? {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
        layout.scrollDirection = .horizontal
        let cw = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cw.backgroundColor = self.contentView.backgroundColor
        cw.delegate = self
        cw.dataSource = self
        cw.isScrollEnabled = false
        cw.register(cellType: BCComicCCell.self)
        return cw
    }()
    
    override func configUI() {
        
        let titileLabel = UILabel()
        titileLabel.text = "猜你喜欢"
        contentView.addSubview(titileLabel)
        titileLabel.snp.makeConstraints { (titlelabel) in
            titlelabel.height.equalTo(20)
            titlelabel.top.left.right.equalToSuperview().inset(UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15))
        }
        
        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.top.equalTo(titileLabel.snp.bottom).offset(5)
            $0.left.bottom.right.equalToSuperview()
        }
    }
}

extension BCGuessLikeCell: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model?.comics?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = floor((collectionView.frame.width - 50) / 4)
        let height = collectionView.frame.height - 10
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: BCComicCCell.self)
        cell.style = .withTitle
        cell.model = model?.comics?[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let comic = model?.comics?[indexPath.row] ,let didSelectClosure = didSelectClosure else { return }
        didSelectClosure(comic)
    }
    
}
