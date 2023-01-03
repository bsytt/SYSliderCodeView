//
//  SYSliderImageCodeView.swift
//  SYSliderCodeView
//
//  Created by baoshy on 2022/12/30.
//

import UIKit

class SYCheckSlider: UISlider {
    
    var sliderWH : CGFloat = 40

    var minimumTrackImage : UIImage? {
        didSet {
            self.setMinimumTrackImage(minimumTrackImage, for: .normal)
        }
    }
    var maximumTrackImage : UIImage?{
        didSet {
            self.setMaximumTrackImage(maximumTrackImage, for: .normal)
        }
    }
    
    var thumbImage: UIImage? {
        didSet {
            self.setThumbImage(thumbImage,for: .normal)
            self.setThumbImage(thumbImage,for: .highlighted)
            imageView.image = thumbImage
        }
    }

    //控件圆角
    var cornerRadius : CGFloat = 6 {
        didSet {
            self.layer.masksToBounds = true
            self.layer.cornerRadius = cornerRadius
            label.layer.masksToBounds = true
            label.layer.cornerRadius = cornerRadius
        }
    }
    //显示文字
    var text : String? {
        didSet {
            label.text = text
        }
    }
    var font : UIFont = UIFont.systemFont(ofSize: 16) {
        didSet {
            label.font = UIFont.systemFont(ofSize: 16)
        }
    }
    var textColor : UIColor = UIColor.grayCColor {
        didSet {
            label.textColor = .grayCColor
        }
    }
    var shimmerType : SYShimmerType = .leftToRight {
        didSet {
            label.shimmerType = shimmerType
        }
    }
    //控件边框
    var borderWidth : CGFloat = 1 {
        didSet {
            label.layer.borderWidth = borderWidth
        }
    }
    var borderColor : UIColor = UIColor.grayCColor {
        didSet {
            label.layer.borderColor = borderColor.cgColor
        }
    }
    //滑块圆角
    var sliderCornerRadius : CGFloat = 8 {
        didSet {
            imageView.layer.cornerRadius = sliderCornerRadius
        }
    }
        
    init(frame: CGRect,sliderWH:CGFloat=40) {
        super.init(frame: frame)
        self.sliderWH = sliderWH
        self.addSubview(label)
        self.addSubview(imageView)
        label.layer.zPosition = .greatestFiniteMagnitude
        imageView.layer.zPosition = .greatestFiniteMagnitude
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
    }
    
    func setImageViewFrame(frame:CGRect) {
        imageView.frame = frame
    }
    
    func setImageViewCenter(point:CGPoint) {
        imageView.center = point
    }
    //文字开始动画
    func startShimmer() {
        label.isPlaying = false
        label.startShimmer()
    }
    
    lazy var label: SYShimmerLab = {
        let label = SYShimmerLab(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        label.font = font
        label.textColor = textColor
        label.shimmerType = shimmerType
        return label
    }()
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: self.frame.origin.x, y: (sliderWH-self.frame.height)/2, width: sliderWH, height: sliderWH))
        imageView.backgroundColor = UIColor(red:0.38, green:0.65, blue:0.98, alpha:1.00)
        imageView.contentMode = .center
        return imageView
    }()
}
