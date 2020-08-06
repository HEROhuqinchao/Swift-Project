//
//  BCNavigationBar.swift
//  BCProject
//
//  Created by you&me on 2017/12/4.
//  Copyright © 2017年 杨杨威. All rights reserved.
//

import UIKit

fileprivate let BCDefaultTitleSize:CGFloat = 18
fileprivate let BCDefaultTitleColor = UIColor.black
fileprivate let BCDefaultBgColor = UIColor.white
fileprivate let BCScreenWidth = UIScreen.main.bounds.size.width

class BCNavigationBar: UIView {
    
    var onLeftBtnClick: (()->())?
    var onRightBtnClick: (()->())?

    var bcTitle: String? {
        willSet {
            bcTitleLabel.isHidden = false
            bcSearchbar.isHidden = true
            bcTitleLabel.text = newValue
        }
    }
    
    var bcTitleColor: UIColor? {
        willSet {
            bcTitleLabel.textColor = newValue
        }
    }
    var bcTitleFont: UIFont? {
        willSet {
            bcTitleLabel.font = newValue
        }
    }
    var bcBarBgColor: UIColor? {
        willSet {
            bcBackgroundImageView.isHidden = true
            bcBackgroundView.isHidden = false
            bcBackgroundView.backgroundColor = newValue
        }
    }
    var bcBarBgImage: UIImage? {
        willSet {
            bcBackgroundView.isHidden = true
            bcBackgroundImageView.isHidden = false
            bcBackgroundImageView.image = newValue
        }
    }
    
    
  // fileprivate UI variable
  lazy var bcTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = BCDefaultTitleColor
        label.font = UIFont.systemFont(ofSize: BCDefaultTitleSize)
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()

    lazy var bcSearchbar: UISearchBar = {
        let search = UISearchBar()
        search.barTintColor = UIColor.white
        let searchField = search.value(forKey: "searchField") as? UITextField
        if let bcField = searchField {
            bcField.layer.cornerRadius = 13.0
            bcField.layer.masksToBounds = true
            bcField.font = UIFont.boldSystemFont(ofSize: 13.0)
            let ploceColor = UIColor.hex(hexString: "ffffff")
            let labe = bcField.value(forKey: "placeholderLabel") as? UILabel
            labe?.textColor = ploceColor
            bcField.backgroundColor = UIColor.hex(hexString: "ffffff")
        }
        search.isHidden = true
        return search
    }()

  lazy var bcLeftBtn: UIButton = {
        let button = UIButton()
        button.imageView?.contentMode = .center
        button.isHidden = true
        button.addTarget(self, action: #selector(backClick), for: .touchUpInside)
        return button
    }()
 
 lazy var bcRightBtn: UIButton = {
        let button = UIButton()
        button.imageView?.contentMode = .center
        button.isHidden = true
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.titleLabel?.textColor = UIColor.hex(hexString: "333333")
        button.addTarget(self, action: #selector(rightClick), for: .touchUpInside)
        return button
    }()

    fileprivate lazy var bcBottomLine:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    fileprivate lazy var bcBackgroundView:UIView = {
        let view = UIView()
        return view
    }()
    
    fileprivate lazy var bcBackgroundImageView:UIImageView = {
        let imgView = UIImageView()
        imgView.isHidden = true
        return imgView
    }()
    
    // 初始化的一些方法
   class func getBCNavigationBar() -> BCNavigationBar {
        let frame = CGRect(x: 0, y: 0, width: BCScreenWidth, height: CGFloat(BCNavigationBar.navBarBottom()))
        return BCNavigationBar(frame: frame)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        //fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
        setUI()
    }
    
    func setUI() {
        addSubview(bcBackgroundView)
        addSubview(bcBackgroundImageView)
        addSubview(bcLeftBtn)
        addSubview(bcTitleLabel)
        for searchChidView in bcSearchbar.subviews {
            if searchChidView.isKind(of: UIView.self) {
                if #available(iOS 13.0, * ) {
                    searchChidView.subviews[0].isHidden = true;
                } else {
                    searchChidView.subviews[0].removeFromSuperview()
                }
                
            }
        }
        addSubview(bcSearchbar)
        addSubview(bcRightBtn)
        addSubview(bcBottomLine)
        updateFrame()
        backgroundColor = UIColor.clear
        bcBackgroundView.backgroundColor = BCDefaultBgColor
    }
    
    func updateFrame() {
        let top:CGFloat = BCNavigationBar.isIphoneX() ? 44 : 20 + 6
        let margin:CGFloat = 5
        let buttonHeight:CGFloat = 35
        let buttonWidth:CGFloat = 40
        let titleLabelHeight:CGFloat = 44
        let titleLabelWidth:CGFloat = 180
        
        bcBackgroundView.frame = self.bounds
        bcBackgroundImageView.frame = self.bounds
        bcLeftBtn.frame = CGRect(x: margin, y: top, width: buttonWidth, height: buttonHeight)
        bcLeftBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        bcRightBtn.frame = CGRect(x: BCScreenWidth-buttonWidth-margin, y: top, width: buttonWidth, height: buttonHeight)
        bcRightBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        bcTitleLabel.frame = CGRect(x: (BCScreenWidth-titleLabelWidth)/2.0, y: top - 6, width: titleLabelWidth, height: titleLabelHeight)
        bcSearchbar.frame = CGRect(x: margin + buttonWidth - 10, y: top + 2, width: BCScreenWidth - 2.0*buttonWidth - 2.0*margin + 20, height: buttonHeight - 4)
        bcBottomLine.frame = CGRect(x: 0, y: bounds.height-0.5, width: BCScreenWidth, height: 0.5)
    }
    
}
// MARK: - 导航的事件
extension BCNavigationBar {
    
    func bc_setBottomLineHidden(hidden: Bool) {
        bcBottomLine.isHidden = hidden
    }
    
    func bc_setBackgroundAlpha(alpha: CGFloat) {
        bcBackgroundView.alpha = alpha
        bcBackgroundImageView.alpha = alpha
        bcBottomLine.alpha = alpha
    }
    
    func bc_setTintColor(color: UIColor) {
        bcLeftBtn.setTitleColor(color, for: .normal)
        bcRightBtn.setTitleColor(color, for: .normal)
        bcTitleLabel.textColor = color
    }
    
    //左右按钮的方法
    func bc_setLeftButton(normal: UIImage?, highlighted: UIImage?) {
        bc_setLeftButton(normal: normal, highlighted: highlighted, title: nil, titleColor: nil)
    }
    func bc_setLeftButton(image: UIImage?) {
        bc_setLeftButton(normal: image, highlighted: image, title: nil, titleColor: nil)
    }
    func bc_setLeftButton(title: String, titleColor: UIColor) {
        bc_setLeftButton(normal: nil, highlighted: nil, title: title, titleColor: titleColor)
    }
    
    func bc_setRightButton(normal: UIImage?, highlighted: UIImage?) {
        bc_setRightButton(normal: normal, highlighted: highlighted, title: nil, titleColor: nil)
    }
    func bc_setRightButton(image: UIImage?) {
        bc_setRightButton(normal: image, highlighted: image, title: nil, titleColor: nil)
    }
    func bc_setRightButton(title: String, titleColor: UIColor) {
        bc_setRightButton(normal: nil, highlighted: nil, title: title, titleColor: titleColor)
    }
    
    // 左右按钮私有方法
    private func bc_setLeftButton(normal: UIImage?, highlighted: UIImage?, title: String?, titleColor: UIColor?) {
        bcLeftBtn.isHidden = false
        bcLeftBtn.setImage(normal, for: .normal)
        bcLeftBtn.setImage(highlighted, for: .highlighted)
        bcLeftBtn.setTitle(title, for: .normal)
        bcLeftBtn.setTitleColor(titleColor, for: .normal)
    }
    private func bc_setRightButton(normal: UIImage?, highlighted: UIImage?, title: String?, titleColor: UIColor?) {
        bcRightBtn.isHidden = false
        bcRightBtn.setImage(normal, for: .normal)
        bcRightBtn.setImage(highlighted, for: .highlighted)
        bcRightBtn.setTitle(title, for: .normal)
        bcRightBtn.setTitleColor(titleColor, for: .normal)
    }
}

// MARK: - 导航栏左右按钮事件
extension BCNavigationBar {
    
   @objc func backClick()  {
        if let onClickBack = onLeftBtnClick {
            onClickBack()
        } else {
            let current = UIViewController.bc_currentViewController()
            current.bc_backToViewController(animated: true)
        }
    }
    
    @objc func rightClick()  {
        if let onRight = onRightBtnClick {
            onRight()
        }
    }
}

 //对于 X 的适配
extension BCNavigationBar
{
    class func isIphoneX() -> Bool {
        return UIScreen.main.bounds.equalTo(CGRect(x: 0, y: 0, width: 375, height: 812))
    }
    class func navBarBottom() -> Int {
        return self.isIphoneX() ? 88 : 64;
    }
    class func tabBarHeight() -> Int {
        return self.isIphoneX() ? 83 : 49;
    }
    class func screenWidth() -> Int {
        return Int(UIScreen.main.bounds.size.width)
    }
    class func screenHeight() -> Int {
        return Int(UIScreen.main.bounds.size.height)
    }
}
