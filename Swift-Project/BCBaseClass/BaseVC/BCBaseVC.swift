//
//  BCBaseVC.swift
//  BCSwiftDemo
//
//  Created by NewUser on 2018/6/26.
//  Copyright © 2018年 Shine. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class BCBaseVC: UIViewController {
    
    var bcTabView: UIScrollView? {
        didSet {
            if (bcTabView?.isKind(of: UITableView.self))! {
                let tab = bcTabView as? UITableView
                tab?.tableFooterView = UIView()
            }
            bcTabView?.emptyDataSetSource = self
            bcTabView?.emptyDataSetDelegate = self
            bcTabView?.backgroundColor = UIColor.white
            //如果修改绑定别的类型的表头/表尾 需要重新绑定新的方法
            bcTabView?.bcHead = BCRefreshHeader { [weak self] in self?.lodeData() }
            bcTabView?.bcFoot = BCRefreshFooter(refreshingBlock: { [weak self] in self?.loadMoreData() })
            
        }
    }
    
    var isBaseLoading: Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        // 解决ios11 由于安全区域safeArea问题造成的表的向下偏移
        if #available(iOS 11.0, *) {
            UIScrollView.appearance().contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        configUI()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func configUI() {}
    
    func emptyLoading() { lodeData() }
    
    @objc func lodeData()  {}
    @objc func loadMoreData()  {}
    
}

extension BCBaseVC: DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "NO Data!"
        let font = UIFont.systemFont(ofSize: 17)
        let textColor = UIColor.red
        let attributes = [NSAttributedString.Key.font: font,
                          NSAttributedString.Key.foregroundColor: textColor]
        let attributedString = NSAttributedString(string: text, attributes: attributes)
        return attributedString
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "Safari cannot open the page because your iPhone is not connected to the Internet."
        let font = UIFont(name: "Lato-Regular", size: 16)
        let textColor = UIColor.gray
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineBreakMode = .byWordWrapping
        paragraph.alignment = .center
        paragraph.lineSpacing = 5
        let attributes = [NSAttributedString.Key.font: font ?? UIFont.systemFont(ofSize: 16),
                          NSAttributedString.Key.foregroundColor: textColor,
                          NSAttributedString.Key.paragraphStyle: paragraph]
        let attributedString = NSAttributedString(string: text, attributes: attributes)
        return attributedString
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        if isBaseLoading {
            return UIImage(named: "loading_imgBlue_78x78")
        } else {
            return UIImage(named: "yaofan")
        }
    }
    
    func imageAnimation(forEmptyDataSet scrollView: UIScrollView!) -> CAAnimation! {
 
        let animation = CABasicAnimation(keyPath: "transform")
        animation.fromValue = NSValue(caTransform3D: CATransform3DIdentity)
        animation.toValue  = NSValue(caTransform3D: CATransform3DMakeRotation(CGFloat(Double.pi/2), 0.0, 0.0, 1.0))
        animation.duration = 0.25
        animation.isCumulative = true
        animation.repeatCount = MAXFLOAT
        return animation
    }
    
    func buttonTitle(forEmptyDataSet scrollView: UIScrollView!, for state: UIControl.State) -> NSAttributedString! {
        let text = "重新点击获取"
        let font = UIFont.systemFont(ofSize: 17)
        let textColor = state == .normal ? UIColor.blue : UIColor.white
        let attributes = [NSAttributedString.Key.font: font,
                          NSAttributedString.Key.foregroundColor: textColor]
        let attributedString = NSAttributedString(string: text, attributes: attributes)
        return attributedString
    }
    
    func buttonBackgroundImage(forEmptyDataSet scrollView: UIScrollView!, for state: UIControl.State) -> UIImage! {
        let imageName = state == .normal ? "button_background_foursquare_normal" : "button_background_foursquare_highlight"
        let capInsets = UIEdgeInsets(top: 25, left: 25, bottom: 25, right: 25)
        let rectInsets = UIEdgeInsets(top: 0.0, left: -10, bottom: 0.0, right: -10)
        // 拉伸区域
        let resizableImage = UIImage(named: imageName)?.resizableImage(withCapInsets: capInsets, resizingMode: .stretch)
        //图片位置相对文字偏移
        let newImage = resizableImage?.withAlignmentRectInsets(rectInsets)
        return newImage
    }
    
    func backgroundColor(forEmptyDataSet scrollView: UIScrollView!) -> UIColor! {
        return UIColor.white
    }
   
    func verticalOffset(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
        var vOffset: CGFloat = 0
        if let top = bcTabView?.contentInset.top, top > 0 {
            vOffset = top - 75
        }
        return -vOffset
    }
    //组件彼此分离（默认分隔为11点）
    func spaceHeight(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
        return 20
    }
    // DELEGATE
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func emptyDataSetShouldAllowTouch(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func emptyDataSetShouldAnimateImageView(_ scrollView: UIScrollView!) -> Bool {
        return isBaseLoading
    }
    
    func emptyDataSet(_ scrollView: UIScrollView!, didTap view: UIView!) {
        self.isBaseLoading = true
        emptyLoading()
    }
    
    func emptyDataSet(_ scrollView: UIScrollView!, didTap button: UIButton!) {
        self.isBaseLoading = true
        emptyLoading()
    }
}

extension BCBaseVC {
    func showTipMsg(_ msg: String ,time: Double)  {
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.mode = .text
        hud.label.text = msg
        hud.margin     = 10 // HUD各元素与HUD边缘的间距
        hud.offset.y   = -66 // HUD相对于父视图中心点的x轴偏移量和y轴偏移量
        hud.removeFromSuperViewOnHide = true
        hud.hide(animated: true, afterDelay: time)
        
    }
    
    //显示菊花框
    func showTip(msg : String){
        MBProgressHUD.showAdded(to: self.view, animated: true).label.text = msg
    }
    //隐藏菊花框
    func hidenTip(){
        MBProgressHUD.hide(for: self.view, animated: true)
    }
}

extension UIViewController {
    
    /// 前往的控制器
    ///
    /// - Parameter animated: 是否做动画
    func bc_backToViewController(animated: Bool) {
        if self.navigationController != nil {
            if self.navigationController?.viewControllers.count == 1 {
                self.dismiss(animated: animated, completion: nil)
            } else {
                self.navigationController?.popViewController(animated: animated)
            }
            
        } else if self.presentingViewController != nil {
            self.dismiss(animated: animated, completion: nil)
        }
    }
    
    /// 当前的控制器
    ///
    /// - Returns: 控制器
    class func bc_currentViewController() -> UIViewController {
        if let rootVC = UIApplication.shared.delegate?.window??.rootViewController {
            return self.bc_currentViewController(form: rootVC)
        } else {
            return UIViewController()
        }
    }
    
    /// 根据根控制器的类型返回当前的控制器
    ///
    /// - Parameter fromVC: 根控制器
    /// - Returns: 返回的控制器
    class func bc_currentViewController(form fromVC: UIViewController) -> UIViewController {
        if fromVC.isKind(of: UINavigationController.self) {
            let navigationController = fromVC as! UINavigationController
            return bc_currentViewController(form: navigationController.viewControllers.last!)
        }
        else if fromVC.isKind(of: UITabBarController.self) {
            let tabBarController = fromVC as! UITabBarController
            return bc_currentViewController(form: tabBarController.selectedViewController!)
        }
        else if fromVC.presentedViewController != nil {
            return bc_currentViewController(form: fromVC.presentingViewController!)
        }
        else {
            return fromVC
        }
    }
}

