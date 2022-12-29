//
//  SYShimmerLab.swift
//  SYRadarView
//
//  Created by baoshy on 2022/12/26.
//

import UIKit

enum SYShimmerType {
    case leftToRight
    case rightToLeft
    case auto    //左右来回
    case all     //整体
}
open class SYShimmerLab: UIView {

    var text : String? {
        didSet {
            guard let text = text else { return }
            self.contentLabel.text = text
            self.update()
        }
    }
    var font : UIFont = UIFont.systemFont(ofSize: 14) {
        didSet {
            self.contentLabel.font = font
            self.update()
        }
    }
    var textColor : UIColor = UIColor.grayCColor {
        didSet {
            self.contentLabel.textColor = textColor
            self.update()
        }
    }
    var attributedText : NSAttributedString? {
        didSet {
            guard let attributedText = attributedText else { return }
            self.contentLabel.attributedText = attributedText
            self.update()
        }
    }
    var numberOfLines : Int = 1 {
        didSet {
            self.contentLabel.numberOfLines = numberOfLines
            self.update()
        }
    }
    
    var shimmerType : SYShimmerType = .leftToRight {
        didSet {
            self.update()
        }
    } //闪烁类型，默认LeftToRight
    var isRepeat : Bool = true {
        didSet {
            self.update()
        }
    } //循环播放，默认是
    var shimmerWidth : CGFloat = 20 {
        didSet {
            self.update()
        }
    } //闪烁宽度，默认20
    var shimmerRadius : CGFloat = 20 {
        didSet {
            self.update()
        }
    }//闪烁半径，默认20
    var shimmerColor : UIColor = .white {
        didSet {
            self.maskLabel.textColor = shimmerColor
            self.update()
        }
    } //闪烁颜色，默认白
    var durationTime : TimeInterval = 2 {
        didSet {
            self.update()
        }
    } //持续时间，默认2秒
    var isPlaying : Bool = false    // 正在播放动画
    var charSize : CGSize = CGSize(width: 0, height: 0)      // 文字 size
    var startT : CATransform3D = CATransform3DIdentity       // 高亮移动范围 [startT, endT]
    var endT : CATransform3D = CATransform3DIdentity
    var _translate : CABasicAnimation?
    var translate : CABasicAnimation? {
        get {
            if (_translate == nil) {
                _translate = CABasicAnimation(keyPath: "transform")
            }
            _translate?.duration = self.durationTime
            _translate?.repeatCount = self.isRepeat == true ? MAXFLOAT : 0
            _translate?.autoreverses = self.shimmerType == .auto ? true : false
            
            return _translate;
        }
    } // 位移动画
    
    var _alphaAni : CABasicAnimation?
    var alphaAni : CABasicAnimation? {
        get {
            if (_alphaAni == nil) {
                _alphaAni = CABasicAnimation(keyPath: "opacity")
                _alphaAni?.repeatCount = MAXFLOAT
                _alphaAni?.autoreverses = true
                _alphaAni?.fromValue = 0.0
                _alphaAni?.toValue = 1.0
            }
            _alphaAni?.duration = self.durationTime
            
            return _alphaAni
        }
    } // alpha 动画

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isUserInteractionEnabled = false
        initSubViews()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initSubViews() {
        self.addSubview(contentLabel)
        self.addSubview(maskLabel)
        self.layer.masksToBounds = true
        self.charSize = CGSize(width: self.frame.width, height: self.frame.height)
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        // 刷新布局
        self.contentLabel.frame = self.bounds
        self.maskLabel.frame = self.bounds
        self.maskLayer.frame = CGRect(x: 0, y: 0, width: self.charSize.width, height: self.charSize.height)
    }
    
    func update() {
        if isPlaying { // 如果在播放动画，更新动画
            self.stopShimmer()
            self.startShimmer()
        }
    }
    
    // 刷新 maskLayer 属性值, transform 值
    func freshMaskLayer() {
        if self.shimmerType != .all {
            maskLayer.backgroundColor = UIColor.clear.cgColor
            maskLayer.startPoint = CGPoint(x: 0, y: 0.5)
            maskLayer.endPoint = CGPoint(x: 1, y: 0.5)
            maskLayer.colors = [UIColor.clear.cgColor,UIColor.clear.cgColor,UIColor.white.cgColor,UIColor.white.cgColor,UIColor.clear.cgColor,UIColor.clear.cgColor]
            var w = 1.0
            var sw = 1.0
            if self.charSize.width >= 1 {
                w = self.shimmerWidth / self.charSize.width*0.5
                sw = self.shimmerRadius / self.charSize.width
            }
            maskLayer.locations = [NSNumber(0.0),NSNumber(value: (0.5-w-sw)),NSNumber(value: (0.5-w)),NSNumber(value: (0.5+w)),NSNumber(value: (0.5+w+sw)),NSNumber(1)]
            let startX = self.charSize.width * (0.5 - w - sw)
            let endX = self.charSize.width * (0.5 + w + sw)
            self.startT = CATransform3DMakeTranslation(-endX, 0, 1)
            self.endT = CATransform3DMakeTranslation(self.charSize.width - startX, 0, 1)
        }else {
            maskLayer.backgroundColor = self.shimmerColor.cgColor
            maskLayer.colors = nil
            maskLayer.locations = nil
        }
    }
    
    func copyLabel(dLabel:UILabel) {
        dLabel.attributedText = self.attributedText
        dLabel.text = self.text
        dLabel.font = self.font
        dLabel.numberOfLines = self.numberOfLines
    }
    
    func startShimmer() {   //开始闪烁，闪烁期间更改上面属性立即生效
        DispatchQueue.main.async {
            // 切换到主线程串行队列，下面代码打包成一个事件（原子操作），加到runloop，就不用担心 isPlaying 被多个线程同时修改
            // dispatch_async() 不 strong 持有本 block，也不用担心循环引用
            if self.isPlaying { return}
            self.isPlaying = true
            self.copyLabel(dLabel: self.maskLabel)
            
            self.maskLabel.isHidden = false
            
            self.maskLayer.removeFromSuperlayer()
            self.freshMaskLayer()
            self.maskLabel.layer.addSublayer(self.maskLayer)
            self.maskLabel.layer.mask = self.maskLayer
            switch self.shimmerType {
            case .leftToRight:
                self.maskLayer.transform = self.startT
                self.translate?.fromValue = NSValue(caTransform3D: self.startT)
                self.translate?.toValue = NSValue(caTransform3D: self.endT)
                self.maskLayer.removeAllAnimations()
                self.maskLayer.add(self.translate!, forKey: "start")
                break;
            case .rightToLeft:
                self.maskLayer.transform = self.endT
                self.translate?.fromValue = NSValue(caTransform3D: self.endT)
                self.translate?.toValue = NSValue(caTransform3D: self.startT)
                self.maskLayer.removeAllAnimations()
                self.maskLayer.add(self.translate!, forKey: "start")
                break;
            case .auto:
                self.maskLayer.transform = self.startT
                self.translate?.fromValue = NSValue(caTransform3D: self.startT)
                self.translate?.toValue = NSValue(caTransform3D: self.endT)
                self.maskLayer.removeAllAnimations()
                self.maskLayer.add(self.translate!, forKey: "start")
                break;
            case .all:
                self.maskLayer.transform = CATransform3DIdentity
                self.maskLayer.removeAllAnimations()
                self.maskLayer.add(self.alphaAni!, forKey: "start")
                break;
            default:
                break
            }
        }
    }
    
    func stopShimmer() { //停止闪烁
        DispatchQueue.main.async {
            if (self.isPlaying == false){ return }
            self.isPlaying = false
            self.maskLayer.removeAllAnimations()
            self.maskLayer.removeFromSuperlayer()
            self.maskLabel.isHidden = true
        }
    }
    @objc func willEnterForeground() {
        DispatchQueue.main.async {
            self.isPlaying = false
            self.startShimmer()
        }
    }
    
    lazy var contentLabel: UILabel = {
        let lab = UILabel(frame: self.bounds)
        lab.font = .systemFont(ofSize: 14)
        lab.textColor = UIColor.darkGray
        lab.textAlignment = .center
        return lab
    }()
    
    lazy var maskLabel: UILabel = {
        let lab = UILabel(frame: self.bounds)
        lab.font = .systemFont(ofSize: 14)
        lab.textColor = .darkGray
        lab.isHidden = true
        lab.textAlignment = .center
        return lab
    }()
    
    lazy var maskLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.backgroundColor = UIColor.clear.cgColor
        return layer
    }()
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
