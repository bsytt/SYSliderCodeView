//
//  SYSliderImageCodeView.swift
//  SYSliderCodeView
//
//  Created by baoshy on 2022/12/30.
//

import UIKit

public typealias SliderCodeBlock = (Bool)->()
open class SYSliderCodeView: UIView {
    
    public var changeBlock : SliderCodeBlock?
    var sliderWH : CGFloat = 44
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
            slider.thumbImage = thumbImage
        }
    }
    
    //显示文字
    public var text : String? {
        didSet {
            slider.text = text
        }
    }
    
    //控件圆角
    public var cornerRadius : CGFloat = 6 {
        didSet {
            slider.cornerRadius = cornerRadius
        }
    }
    
    //控件边框
    public var borderWidth : CGFloat = 1 {
        didSet {
            slider.borderWidth = borderWidth
        }
    }
    public var borderColor : UIColor = UIColor.grayCColor {
        didSet {
            slider.borderColor = borderColor
        }
    }
    
    //滑块圆角
    public var sliderCornerRadius : CGFloat = 8 {
        didSet {
            slider.sliderCornerRadius = sliderCornerRadius
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
        createCodeTypeSlider()
    }
    
    //创建滑块验证
    func createCodeTypeSlider() {
        self.addSubview(slider)
        startShimmer()
    }
    
    
    //文字开始动画
    public func startShimmer() {
        slider.startShimmer()
    }
    
    public func didCancel() {
        self.changeBlock?(false)
        self.slider.setValue(0, animated: true)
        self.slider.setImageViewFrame(frame: CGRect(x: self.slider.frame.origin.x, y: self.slider.frame.origin.y-(sliderWH-self.frame.height)/2, width: sliderWH, height: sliderWH))
    }
    
    @objc func valueChange(slider:UISlider) {
        self.slider.setValue(slider.value, animated: false)
        if slider.value > 0 {
            self.slider.setMinimumTrackImage(minimumTrackImage, for: .normal)
        }else {
            self.slider.setMinimumTrackImage(maximumTrackImage, for: .normal)
        }

        self.slider.setImageViewCenter(point: CGPoint(x: self.slider.frame.origin.x+CGFloat(slider.value)*(self.slider.frame.width-40)+20, y: self.slider.center.y))

        if (!slider.isTracking && slider.value != 1) {
            self.slider.setValue(0, animated: true)
            if slider.value > 0 {
                self.slider.setMinimumTrackImage(minimumTrackImage, for: .normal)
            }else {
                self.slider.setMinimumTrackImage(maximumTrackImage, for: .normal)
            }
            self.slider.setImageViewFrame(frame: CGRect(x: self.slider.frame.origin.x, y: self.slider.frame.origin.y-(sliderWH-self.frame.height)/2, width: sliderWH, height: sliderWH))
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
}
