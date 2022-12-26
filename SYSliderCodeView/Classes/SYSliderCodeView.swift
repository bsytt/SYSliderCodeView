//
//  SliderCodeView.swift
//  SYRadarView
//
//  Created by baoshy on 2022/12/22.
//

import UIKit

public typealias SliderCodeBlock = (Bool)->()
open class SYSliderCodeView: UIView {
    public var changeBlock : SliderCodeBlock?
    
    public var minimumTrackImage : UIImage? {
        didSet {
            slider.setMinimumTrackImage(minimumTrackImage, for: .normal)
        }
    }
    public var maximumTrackImage : UIImage?{
        didSet {
            slider.setMaximumTrackImage(maximumTrackImage, for: .normal)
        }
    }
    
    public var thumbImage: UIImage? {
        didSet {
            slider.setThumbImage(thumbImage,for: .normal)
            slider.setThumbImage(thumbImage,for: .highlighted)
            imageView.image = thumbImage
        }
    }
    
    //显示文字
    public var text : String? {
        didSet {
            label.text = text
            label.font = UIFont.systemFont(ofSize: 16)
            label.textColor = .grayCColor
        }
    }
    
    //控件是否有圆角（默认有）
    public var isCornerRadius : Bool = false
    public var cornerRadius : CGFloat = 6 {
        didSet {
            if isCornerRadius {
                slider.layer.masksToBounds = true
                slider.layer.cornerRadius = cornerRadius
                label.layer.masksToBounds = true
                label.layer.cornerRadius = cornerRadius
            }
        }
    }
    
    //控件是否有边框
    public var isBorder : Bool = false
    public var borderWidth : CGFloat = 1 {
        didSet {
            if isBorder {
                label.layer.borderWidth = borderWidth
            }
        }
    }
    public var borderColor : UIColor = UIColor.grayCColor {
        didSet {
            if isBorder {
                label.layer.borderColor = borderColor.cgColor
            }
        }
    }
    
    var sliderWH : CGFloat = 44
    //滑块是否有圆角
    public var isSliderCornerRadius : Bool = true
    public var sliderCornerRadius : CGFloat = 8 {
        didSet {
            if isSliderCornerRadius {
                imageView.layer.cornerRadius = sliderCornerRadius
            }
        }
    }
    
    public init(frame: CGRect,sliderWH:CGFloat = 44) {
        super.init(frame: frame)
        self.sliderWH = sliderWH
        initSubViews()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initSubViews() {
        self.addSubview(slider)
        self.addSubview(label)
        self.addSubview(imageView)
        startShimmer()
    }
    
    //文字开始动画
    public func startShimmer() {
        label.isPlaying = false
        label.startShimmer()
    }
    
    public func didCancel() {
        self.changeBlock?(false)
        self.slider.setValue(0, animated: true)
        self.imageView.frame = CGRect(x: self.slider.frame.origin.x, y: self.slider.frame.origin.y-(sliderWH-self.frame.height)/2, width: sliderWH, height: sliderWH)
    }
    
    @objc func valueChange(slider:UISlider) {
        self.slider.setValue(slider.value, animated: false)
        if slider.value > 0 {
            self.slider.setMinimumTrackImage(minimumTrackImage, for: .normal)
        }else {
            self.slider.setMinimumTrackImage(maximumTrackImage, for: .normal)
        }

        imageView.center = CGPoint(x: self.slider.frame.origin.x+CGFloat(slider.value)*(self.slider.frame.width-40)+20, y: self.slider.center.y)

        if (!slider.isTracking && slider.value != 1) {
            self.slider.setValue(0, animated: true)
            if slider.value > 0 {
                self.slider.setMinimumTrackImage(minimumTrackImage, for: .normal)
            }else {
                self.slider.setMinimumTrackImage(maximumTrackImage, for: .normal)
            }
            imageView.frame = CGRect(x: self.slider.frame.origin.x, y: self.slider.frame.origin.y-(sliderWH-self.frame.height)/2, width: sliderWH, height: sliderWH)
        }
        if (!slider.isTracking && slider.value == 1) {
            if slider.state.rawValue == 1 {
                self.changeBlock?(true)
            }else {
                self.changeBlock?(false)
            }
        }else if (!slider.isTracking && slider.value == 0) {
            if slider.state.rawValue == 1 {
                self.changeBlock?(false)
            }
        }
    }
    
    lazy var slider: SYCheckSlider = {
        let slider = SYCheckSlider(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        slider.minimumTrackTintColor = .clear
        slider.maximumTrackTintColor = .clear
        slider.addTarget(self, action: #selector(valueChange(slider:)), for: .valueChanged)
        return slider
    }()
    lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: slider.frame.origin.x, y: slider.frame.origin.y-(sliderWH-self.frame.height)/2, width: sliderWH, height: sliderWH))
        imageView.backgroundColor = UIColor(red:0.38, green:0.65, blue:0.98, alpha:1.00)
        imageView.contentMode = .center
        return imageView
    }()
    lazy var label: SYShimmerLab = {
        let label = SYShimmerLab(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height));
//        label.shimmerType = .auto
        return label
    }()
    
}
