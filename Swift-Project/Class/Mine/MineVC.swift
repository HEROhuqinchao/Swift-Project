//
//  MineVC.swift
//  Swift-Project
//
//  Created by 胡勤超 on 2020/8/6.
//  Copyright © 2020 胡勤超. All rights reserved.
//

import UIKit
import AutoInch   ///AutoInch - 优雅的iPhone等比例/全尺寸精准适配工具 ->首先导入


class MineVC: BCCustomNavVC {
    @IBOutlet weak var headImg: UIImageView!
    @IBOutlet weak var nameLb: UILabel!
    
    @IBOutlet weak var sexBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameLb.text = "来福".i35("常威").i40("周星星").i55("憨憨").i58full("臭豆腐")
        headImg.cornerRadius = 30.auto()
        headImg.image = UIImage(named: "img_tx".i35("img_tx2").i40("img_tx3".i58full("img_tx4".i65full("img_tx5"))))
        sexBtn.setTitle("男", for: UIControl.State.normal)
    }


    
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
