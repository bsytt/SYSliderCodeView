//
//  UIImageExtension.swift
//  Nongjibang
//
//  Created by xiyang on 2017/8/10.
//  Copyright © 2017年 gaofan. All rights reserved.
//

import Foundation
import UIKit
extension UIImage{
    
    class func navigationBarImage(imgColor color:UIColor) -> UIImage {
        
        let rect = CGRect(x: 0, y: 0, width: kScreenWidth, height: 64)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return img!
    }
    class func createImage(imgColor color:UIColor,size:CGSize) -> UIImage {
        
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return img ?? UIImage()
    }
    func kt_drawRectWithRoundedCorner(radius: CGFloat, sizetoFit: CGSize) -> UIImage {
        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: sizetoFit)
        
        UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.main.scale)
        
        UIGraphicsGetCurrentContext()?.addPath(UIBezierPath(roundedRect: rect, byRoundingCorners: UIRectCorner.allCorners,
                                                            cornerRadii: CGSize(width: radius, height: radius)).cgPath)
        UIGraphicsGetCurrentContext()?.clip()
        
        self.draw(in: rect)
        UIGraphicsGetCurrentContext()?.drawPath(using: .fillStroke)
        let output = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return output ?? UIImage()
    }
    /// 更改图片颜色
    public func imageWithTintColor(color : UIColor) -> UIImage{
        UIGraphicsBeginImageContext(self.size)
        color.setFill()
        let bounds = CGRect.init(x: 0, y: 0, width: self.size.width, height: self.size.height)
        UIRectFill(bounds)
        self.draw(in: bounds, blendMode: CGBlendMode.destinationIn, alpha: 1.0)
        
        let tintedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return tintedImage!
    }
    //生成圆形图片
    func toCircle() -> UIImage {
        //取最短边长
        let shotest = min(self.size.width, self.size.height)
        //输出尺寸
        let outputRect = CGRect(x: 0, y: 0, width: shotest, height: shotest)
        //开始图片处理上下文（由于输出的图不会进行缩放，所以缩放因子等于屏幕的scale即可）
        UIGraphicsBeginImageContextWithOptions(outputRect.size, false, 0)
        let context = UIGraphicsGetCurrentContext()
        //添加圆形裁剪区域
        context?.addEllipse(in: outputRect)
        context?.clip()
        //绘制图片
        self.draw(in: CGRect(x: (shotest-self.size.width)/2,
                             y: (shotest-self.size.height)/2,
                             width: self.size.width,
                             height: self.size.height))
        //获得处理后的图片
        let maskedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return maskedImage ?? UIImage()
    }
    //图片等比缩放
    func scaleImage(newWidth:CGFloat) -> UIImage {
        let imgH = self.size.height
        let imgW = self.size.width
        let width:CGFloat!
        let height:CGFloat!
        if imgW > newWidth {
            width = newWidth
            height = imgH*width/imgW
        }else if imgW < newWidth {
            width = newWidth
            height = imgH*width/imgW
        }else {
            width = imgW
            height = imgH
        }
        
        UIGraphicsBeginImageContext(CGSize(width: width, height: height))
        self.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
    
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return scaledImage!
    }
    static func sy_imageWithColor(color:UIColor,size:CGSize)->UIImage {
        UIGraphicsBeginImageContext(size)
        color.set()
        UIRectFill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    //图片中截取图片
    func getImageFromImage(_ newImageRect:CGRect) -> UIImage {
        let imageRef = self.cgImage;
        let subImageRef = imageRef!.cropping(to: newImageRect);
        return UIImage(cgImage: subImageRef!)
    }
    
}

extension UIImageView {
    /**
     / !!!只有当 imageView 不为nil 时，调用此方法才有效果
     
     :param: radius 圆角半径
     */
    func kt_addCorner(radius: CGFloat,size:CGSize) {
        self.image = self.image?.kt_drawRectWithRoundedCorner(radius: radius, sizetoFit: size)
    }
}



