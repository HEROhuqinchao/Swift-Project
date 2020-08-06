//
//  BCImageEx.swift
//  BCSwiftDemo
//
//  Created by NewUser on 2018/6/26.
//  Copyright © 2018年 Shine. All rights reserved.
//

import Foundation


extension UIImage {
    /*
     缩放图片到指定size
     */
    func scaleImage(_ size : CGSize) -> UIImage {
        //创建上下文
        UIGraphicsBeginImageContextWithOptions(size, true, self.scale)
        self.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    /*
     图片裁剪内切圆  异步绘制
     */
    class func clipCircleImage( _ image : UIImage?,
                                _ resultBlock: @escaping(_ newImage: UIImage?)->()) {
        
        guard let realImage = image else { return }
        //全局队列的异步线程
        DispatchQueue.global().async {
            // 获取图片上下文章
            UIGraphicsBeginImageContext(realImage.size)
            // 利用贝塞尔曲线裁剪
            let clipBezier = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: realImage.size.width, height: realImage.size.height))
           //把路径设置为裁剪区域(超出裁剪区域以外的内容会被自动裁剪掉)
            clipBezier.addClip()
            //把图片绘制到上下文当中
            realImage.draw(at: CGPoint.zero)
            // 获取当前的上下文
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            // 关闭上下文
            UIGraphicsEndImageContext()
            // 回到主线程 完成回调
            DispatchQueue.main.async {
                resultBlock(newImage)
            }
        }
    
    }
    
    
}

