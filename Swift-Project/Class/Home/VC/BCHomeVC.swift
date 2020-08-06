//
//  BCHomeVC.swift
//  BCSwiftDemo
//
//  Created by NewUser on 2018/7/2.
//  Copyright © 2018年 Shine. All rights reserved.
//

import UIKit

class BCHomeVC: BCPageViewController {

    static let share = BCHomeVC()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configNavigationBar() {
        super.configNavigationBar()
        let seachBtn = UIButton()
        seachBtn.sizeToFit()
        seachBtn.setImage(#imageLiteral(resourceName: "nav_search"), for: .normal)
        seachBtn.addTarget(self, action: #selector(BCHomeVC.seachClick(_:)), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: seachBtn)
    }
    
    @objc private func seachClick(_ sender: UIButton) {
        let vc = SearchVC()
        navigationController?.pushViewController(vc, animated: true)
    }
}
