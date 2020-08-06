//
//  GYGaussianBlur.swift
//  SwiftDemo
//
//  Created by lyons on 2019/3/7.
//  Copyright © 2019 lyons. All rights reserved.
//

import UIKit
import Accelerate
import Kingfisher

extension UIImageView{
    
    /// UIImageView动态高斯模糊
    ///
    /// - Parameters:
    ///   - resource: 图片资源
    ///   - blurNumber: 模糊度
    ///   - placeholder: 默认图
    ///   - options: 可以控制一些行为的字典（具体查看Kingfisher文档）
    ///   - progressBlock: 当图像下载进度更新时调用
    ///   - completionHandler: 回调
    /// - Returns: 在检索和设置图像时调用
    @discardableResult
    public func setGaussianBlurImage(with resource: Resource?,
                                     blurNumber: Float?,
                                     placeholder: Placeholder? = nil,
                                     options: KingfisherOptionsInfo? = nil,
                                     progressBlock: DownloadProgressBlock? = nil,
                                     completionHandler: ((Result<RetrieveImageResult, KingfisherError>) -> Void)? = nil) -> DownloadTask? {
        return self.kf.setImage(with: resource, placeholder: placeholder, options: options, progressBlock: progressBlock) { (result) in
            switch result {
            case .success(let value):
                self.image = value.image.gaussianBlur(blurNumber: blurNumber ?? 0.0)
            case .failure( _):
                break
            }
        }
    }
}

extension UIImage {
    /// UIImage高斯模糊
    ///
    /// - Parameter blurNumber: 模糊度
    /// - Returns: 高斯模糊后的image
    func gaussianBlur(blurNumber: Float) -> UIImage {
        var blur = blurNumber
        if blur < 0.0 || blur > 1.0 {
            blur = 0.5
        }
        var boxSize = Int(blur * 40)
        boxSize = boxSize - (boxSize % 2) + 1
        
        let img = self.cgImage!
        
        var inBuffer = vImage_Buffer()
        var outBuffer = vImage_Buffer()
        var error: vImage_Error!
        var pixelBuffer: UnsafeMutableRawPointer?
        
        // 从CGImage中获取数据
        let inProvider = img.dataProvider!
        let inBitmapData = inProvider.data!
        
        // 设置从CGImage获取对象的属性
        inBuffer.width = UInt(img.width)
        inBuffer.height = UInt(img.height)
        inBuffer.rowBytes = img.bytesPerRow
        inBuffer.data = UnsafeMutableRawPointer(mutating: CFDataGetBytePtr(inBitmapData))
        pixelBuffer = malloc(img.bytesPerRow * img.height)
        if pixelBuffer == nil {
            print("No pixel buffer!")
        }
        
        outBuffer.data = pixelBuffer
        outBuffer.width = UInt(img.width)
        outBuffer.height = UInt(img.height)
        outBuffer.rowBytes = img.bytesPerRow
        
        error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, nil, 0, 0, UInt32(boxSize), UInt32(boxSize), nil, UInt32(kvImageEdgeExtend))
        if error != nil && error != 0 {
            print("error from convolution \(error!)")
        }
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let ctx = CGContext(data: outBuffer.data, width: Int(outBuffer.width), height: Int(outBuffer.height), bitsPerComponent: 8, bytesPerRow: outBuffer.rowBytes, space: colorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue)
        
        let imageRef = ctx!.makeImage()!
        let returnImage = UIImage(cgImage: imageRef)
        
        //释放内存
        free(pixelBuffer)
        
        return returnImage
    }
}

