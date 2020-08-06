//
//  BCDetailVC.swift
//  BCSwiftDemo
//
//  Created by NewUser on 2018/7/30.
//  Copyright © 2018年 Shine. All rights reserved.
//

import UIKit

class BCDetailVC: BCBaseVC {

    weak var delegate: BCComicViewScrollDelegate?
    
    var detailStatic: DetailStaticModel?
    var detailRealtime: DetailRealtimeModel?
    var guessLike: GuessLikeModel?
    
    private  lazy var tableView: UITableView = {
        let tw = UITableView(frame: .zero, style: .plain)
        tw.delegate = self
        tw.backgroundColor = UIColor(r: 242, g: 242, b: 242)
        tw.dataSource = self
        tw.separatorStyle = .none
        tw.rowHeight = UITableView.automaticDimension
        tw.register(cellType: BCDescriptionCell.self)
        tw.register(cellType: BCOtherWorksCell.self)
        tw.register(cellType: BCTicketCell.self)
        tw.register(cellType: BCGuessLikeCell.self)
        return tw
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func reloadData() {
        tableView.reloadData()
    }
    
    override func configUI() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { $0.edges.equalTo(self.view.usnp.edges) }
    }
   
}

extension BCDetailVC: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        delegate?.comicWillEndDragging(scrollView)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return detailStatic != nil ? 4 : 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (section == 1 && detailStatic?.otherWorks?.count == 0) ? 0 : 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return (section == 1 && detailStatic?.otherWorks?.count == 0) ? CGFloat.leastNormalMagnitude : 10
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return UITableView.automaticDimension
        } else if indexPath.section == 3{
            return 200
        } else {
            return 44
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: BCDescriptionCell.self)
            cell.model = detailStatic
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: BCOtherWorksCell.self)
            cell.model = detailStatic
            return cell
        } else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: BCTicketCell.self)
            cell.model = detailRealtime
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: BCGuessLikeCell.self)
            cell.model = guessLike
            cell.didSelectClosure = { [weak self] model in
                let vc = BCComicVC(comicid: model.comic_id)
                self?.navigationController?.pushViewController(vc, animated: true)
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let vc = BCOtherWorkerVC(otherWorks: detailStatic?.otherWorks)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
