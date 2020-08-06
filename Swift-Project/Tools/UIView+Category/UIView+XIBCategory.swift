//
//  UIView+XIBCategory.swift
//  Swift-Project
//
//  Created by 胡勤超 on 2020/8/6.
//  Copyright © 2020 胡勤超. All rights reserved.
//

import Foundation
import UIKit
/// 方向
///
/// - top: 上
/// - left: 下
/// - bottom: 左
/// - right: 右
enum Direction {
    case top
    case left
    case bottom
    case right
}

extension UIView {
    // input code
    public var x: CGFloat{
        get{
            return self.frame.origin.x
        }
        set{
            var r = self.frame
            r.origin.x = newValue
            self.frame = r
        }
    }
    
    public var y: CGFloat{
        get{
            return self.frame.origin.y
        }
        set{
            var r = self.frame
            r.origin.y = newValue
            self.frame = r
        }
    }
    /// 右边界的x值
    public var rightX: CGFloat{
        get{
            return self.x + self.width
        }
        set{
            var r = self.frame
            r.origin.x = newValue - frame.size.width
            self.frame = r
        }
    }
    /// 下边界的y值
    public var bottomY: CGFloat{
        get{
            return self.y + self.height
        }
        set{
            var r = self.frame
            r.origin.y = newValue - frame.size.height
            self.frame = r
        }
    }
    
    public var centerX : CGFloat{
        get{
            return self.center.x
        }
        set{
            self.center = CGPoint(x: newValue, y: self.center.y)
        }
    }
    
    public var centerY : CGFloat{
        get{
            return self.center.y
        }
        set{
            self.center = CGPoint(x: self.center.x, y: newValue)
        }
    }
    
    public var width: CGFloat{
        get{
            return self.frame.size.width
        }
        set{
            var r = self.frame
            r.size.width = newValue
            self.frame = r
        }
    }
    public var height: CGFloat{
        get{
            return self.frame.size.height
        }
        set{
            var r = self.frame
            r.size.height = newValue
            self.frame = r
        }
    }
    
    
    public var origin: CGPoint{
        get{
            return self.frame.origin
        }
        set{
            self.x = newValue.x
            self.y = newValue.y
        }
    }
    
    public var size: CGSize{
        get{
            return self.frame.size
        }
        set{
            self.width = newValue.width
            self.height = newValue.height
        }
    }
    
    /// 右上角坐标
    var topRight: CGPoint {
        get {
            return CGPoint(x: frame.origin.x + frame.size.width, y: frame.origin.y)
        }
        set(newValue) {
            frame.origin = CGPoint(x: newValue.x - width, y: newValue.y)
        }
    }
    
    /// 右下角坐标
    var bottomRight: CGPoint {
        get {
            return CGPoint(x: frame.origin.x + frame.size.width, y: frame.origin.y + frame.size.height)
        }
        set(newValue) {
            frame.origin = CGPoint(x: newValue.x - width, y: newValue.y - height)
        }
    }
    
    /// 左下角坐标
    var bottomLeft: CGPoint {
        get {
            return CGPoint(x: frame.origin.x, y: frame.origin.y + frame.size.height)
        }
        set(newValue) {
            frame.origin = CGPoint(x: newValue.x, y: newValue.y - height)
        }
    }
    /// 获取UIView对象某个方向缩进指定距离后的方形区域
    ///
    /// - Parameters:
    ///   - direction: 要缩进的方向
    ///   - distance: 缩进的距离
    /// - Returns: 得到的区域
    func cutRect(direction: Direction, distance: CGFloat) ->  CGRect {
        switch direction {
        case .top:
            return CGRect(x: 0, y: distance, width: width, height: height - distance)
        case .left:
            return CGRect(x: distance, y: 0, width: width - distance, height: height)
        case .right:
            return CGRect(x: 0, y: 0, width: width - distance, height: height)
        case .bottom:
            return CGRect(x: 0, y: 0, width: width, height: height - distance)
        }
    }
    
    
    
    /// 给uivew写一个扩展，定义三个属性
    
    @IBInspectable var borderColor: UIColor {
        get {
            return UIColor(cgColor: self.layer.borderColor!)
        }
        set {
            self.layer.borderColor = newValue.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return self.layer.borderWidth
        }
        set {
            self.layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
            self.layer.masksToBounds = newValue > 0
        }
    }
    
    
    @IBInspectable var masksToBounds: Bool {
        get {
            return self.layer.masksToBounds
        }
        set {
            self.layer.masksToBounds = newValue
        }
    }
    
}


/// 自定义view-->渐变色View，用@IBDesignable修饰
@IBDesignable
class LDGradientView: UIView {
    
    // the gradient start colour
    @IBInspectable var startColor: UIColor? {
        didSet {
            updateGradient()
        }
    }
    
    // the gradient end colour
    @IBInspectable var endColor: UIColor? {
        didSet {
            updateGradient()
        }
    }
    
    // the gradient angle, in degrees anticlockwise from 0 (east/right)
    @IBInspectable var angle: CGFloat = 270 {
        didSet {
            updateGradient()
        }
    }
    
    // the gradient layer
    private var gradient: CAGradientLayer?
    
    // initializers
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        installGradient()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        installGradient()
    }
    
    // Create a gradient and install it on the layer
    private func installGradient() {
        // if there's already a gradient installed on the layer, remove it
        if let gradient = self.gradient {
            gradient.removeFromSuperlayer()
        }
        let gradient = createGradient()
        self.layer.addSublayer(gradient)
        self.gradient = gradient
    }
    
    // Update an existing gradient
    private func updateGradient() {
        if let gradient = self.gradient {
            let startColor = self.startColor ?? UIColor.clear
            let endColor = self.endColor ?? UIColor.clear
            gradient.colors = [startColor.cgColor, endColor.cgColor]
            let (start, end) = gradientPointsForAngle(self.angle)
            gradient.startPoint = start
            gradient.endPoint = end
        }
    }
    
    // create gradient layer
    private func createGradient() -> CAGradientLayer {
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        return gradient
    }
    
    // create vector pointing in direction of angle
    private func gradientPointsForAngle(_ angle: CGFloat) -> (CGPoint, CGPoint) {
        // get vector start and end points
        let end = pointForAngle(angle)
        //let start = pointForAngle(angle+180.0)
        let start = oppositePoint(end)
        // convert to gradient space
        let p0 = transformToGradientSpace(start)
        let p1 = transformToGradientSpace(end)
        return (p0, p1)
    }
    
    // get a point corresponding to the angle
    private func pointForAngle(_ angle: CGFloat) -> CGPoint {
        // convert degrees to radians
        let radians = angle * .pi / 180.0
        var x = cos(radians)
        var y = sin(radians)
        // (x,y) is in terms unit circle. Extrapolate to unit square to get full vector length
        if (abs(x) > abs(y)) {
            // extrapolate x to unit length
            x = x > 0 ? 1 : -1
            y = x * tan(radians)
        } else {
            // extrapolate y to unit length
            y = y > 0 ? 1 : -1
            x = y / tan(radians)
        }
        return CGPoint(x: x, y: y)
    }
    
    // transform point in unit space to gradient space
    private func transformToGradientSpace(_ point: CGPoint) -> CGPoint {
        // input point is in signed unit space: (-1,-1) to (1,1)
        // convert to gradient space: (0,0) to (1,1), with flipped Y axis
        return CGPoint(x: (point.x + 1) * 0.5, y: 1.0 - (point.y + 1) * 0.5)
    }
    
    // return the opposite point in the signed unit square
    private func oppositePoint(_ point: CGPoint) -> CGPoint {
        return CGPoint(x: -point.x, y: -point.y)
    }
    
    // ensure the gradient gets initialized when the view is created in IB
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        installGradient()
        updateGradient()
    }
}
