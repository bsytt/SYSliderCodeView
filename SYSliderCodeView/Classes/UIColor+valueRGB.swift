//
//  SYSliderImageCodeView.swift
//  SYSliderCodeView
//
//  Created by baoshy on 2022/12/30.
//

import UIKit

extension UIColor{

    //用数值初始化颜色，便于生成设计图上标明的十六进制颜色
    public convenience init(hexString: String) {
        
        var cStr : String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        if cStr.hasPrefix("#") {
            let index = cStr.index(after: cStr.startIndex)
            let endIndex = cStr.endIndex
            cStr = String(cStr[index ..< endIndex])
        }
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        if cStr.count == 6 {
            
            let rRange = cStr.startIndex ..< cStr.index(cStr.startIndex, offsetBy: 2)
            let rStr = String(cStr[rRange])
            
            let gRange = cStr.index(cStr.startIndex, offsetBy: 2) ..< cStr.index(cStr.startIndex, offsetBy: 4)
            let gStr = String(cStr[gRange])
            
            let bIndex = cStr.index(cStr.endIndex, offsetBy: -2)
            let endIndex = cStr.endIndex
            let bStr = String(cStr[bIndex ..< endIndex])
            
            Scanner(string: rStr).scanHexInt32(&r)
            Scanner(string: gStr).scanHexInt32(&g)
            Scanner(string: bStr).scanHexInt32(&b)
        }
        
        self.init(
            red: CGFloat(r) / 255.0,
            green: CGFloat(g) / 255.0,
            blue: CGFloat(b) / 255.0,
            alpha: 1.0
        )
    }
   
    public static var gray2Color: UIColor {
        return UIColor(hexString: "222222")
    }
   
    public static var gray3Color: UIColor {
        return UIColor(hexString: "333333")
    }
    public static var gray4Color: UIColor {
        return UIColor(hexString: "444444")
    }
    public static var gray5Color: UIColor{
        return UIColor(hexString: "555555")
    }
    public static var gray6Color: UIColor{
        return UIColor(hexString: "666666")
    }
    public static var gray8Color: UIColor{
        return UIColor(hexString: "888888")
    }
    public static var gray9Color: UIColor{
        return UIColor(hexString: "999999")
    }
    public static var grayCColor: UIColor{
        return UIColor(hexString: "cccccc")
    }
    public static var grayBColor: UIColor{
        return UIColor(hexString: "BBBBBB")
    }
    //主题颜色
    public static var themeColor: UIColor{
        return UIColor(hexString: "#1582FA")
    }
}

extension UIImage {
    ///截取当前image对象rect区域内的图像
    func sy_subImageWithRect(rect:CGRect) -> UIImage? {
        let scale = self.scale
        let scaleRect = CGRect(x: rect.origin.x*scale, y: rect.origin.y*scale, width: rect.width*scale, height: rect.height*scale)
        let newImageRef = self.cgImage?.cropping(to: scaleRect)
        if let newImageRef = newImageRef {
            let newImage = UIImage(cgImage: newImageRef).sy_RescaleImage(to: rect.size)
            return newImage
        }
        return nil
    }
    ///按给定path剪裁图片
    /**
     path:路径，剪裁区域。
     mode:填充模式
     */
    func sy_ClipImageWithPath(path:UIBezierPath,mode:SliderCodeContentMode) -> UIImage? {
        let originScale: CGFloat = size.width * 1.0 / size.height
        let boxBounds = path.bounds
        var width = boxBounds.size.width
        var height = width / originScale
        switch mode {
        case .scaleAspectFit:
            if height > boxBounds.height {
                height = boxBounds.height
                width = height * originScale
            }
            break
        case .scaleAspectFill:
            if height < boxBounds.height {
                height = boxBounds.height
                width = height * originScale
            }
            break
        case .scaleToFill:
            if height != boxBounds.height {
                height = boxBounds.height
            }
            break
        default:
            break
        }
        UIGraphicsBeginImageContextWithOptions(boxBounds.size, false, UIScreen.main.scale)
        let bitmap = UIGraphicsGetCurrentContext()
        
        let newPath : UIBezierPath = path.copy() as! UIBezierPath
        newPath.apply(CGAffineTransformMakeTranslation(-path.bounds.origin.x, -path.bounds.origin.y))
        newPath.addClip()
        //移动原点至图片中心
        bitmap?.translateBy(x: boxBounds.size.width / 2.0, y: boxBounds.size.height / 2.0)
        bitmap?.scaleBy(x: 1.0, y: -1.0)
        bitmap?.draw(cgImage!, in: CGRect(x: -width / 2, y: -height / 2, width: width, height: height))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if let newImage = newImage {
            return newImage
        }
        return nil
    }
    ///压缩图片至指定尺寸
    func sy_RescaleImage(to size: CGSize) -> UIImage? {
        let rect = CGRect(origin: CGPoint.zero, size: size)

        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)

        draw(in: rect)

        let resImage = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()

        return resImage
    }
}
