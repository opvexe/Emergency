//
//  EGImageExtent.swift
//  Emergency
//
//  Created by shumin.tao on 2017/5/25.
//  Copyright © 2017年 yidian. All rights reserved.
//

import UIKit

 extension UIImage {
    //颜色转换成图片
  open class func getImageWithColor(color:UIColor)->UIImage{
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    //高斯模糊
  open class func originalImageBlur(originalImage:UIImage, blurAmount:NSNumber) -> UIImage {
        
        let inputImage =  CIImage(image: originalImage)
        //使用高斯模糊滤镜
        let filter = CIFilter(name: "CIGaussianBlur")!
        filter.setValue(inputImage, forKey:kCIInputImageKey)
        //设置模糊半径值（越大越模糊）
        filter.setValue(blurAmount, forKey: kCIInputRadiusKey)
        let outputCIImage = filter.outputImage!
        let rect = CGRect(origin: CGPoint.zero, size: originalImage.size)
        let contexts = CIContext.init(options: nil)
        let cgImage = contexts.createCGImage(outputCIImage, from: rect)
         return UIImage(cgImage: cgImage!)
    }
}

 extension UIImageView {
    // 裁剪 的圆角
    func clipRectCorner(direction: UIRectCorner, cornerRadius: CGFloat) {
        let cornerSize = CGSize(width: cornerRadius, height: cornerRadius)
        let maskPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: direction, cornerRadii: cornerSize)
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = maskPath.cgPath
        layer.addSublayer(maskLayer)
        layer.mask = maskLayer
    }
}



