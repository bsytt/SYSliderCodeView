//
//  SYSliderImageCodeView.swift
//  SYSliderCodeView
//
//  Created by baoshy on 2022/12/30.
//

import UIKit

extension UIImage{

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
    
}



