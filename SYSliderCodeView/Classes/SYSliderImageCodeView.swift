//
//  SYSliderImageCodeView.swift
//  SYSliderCodeView
//
//  Created by baoshy on 2022/12/30.
//

import UIKit

public typealias SliderImgCodeBlock = (String)->()
public enum SYSliderDrawPathType {
    case defaultType
    case customType
}
open class SYSliderDrawPath : NSObject {
    public static let shared = SYSliderDrawPath()
    
    //滑块大小
    var codeSize:CGSize = CGSize(width: 50, height: 50)
    //间距
    let margin:CGFloat = 10
    //贝塞尔曲线偏移
    let offset:CGFloat = 9
    var customPath : UIBezierPath?
    var type : SYSliderDrawPathType = .defaultType
    public func createPath(type:SYSliderDrawPathType = .defaultType,customPath : UIBezierPath? = nil,codeSize:CGSize = CGSize(width: 50, height: 50)) -> SYSliderDrawPath {
        self.type = type
        self.codeSize = codeSize
        if type == .defaultType {
            self.customPath = getPath()
        }else {
            self.customPath = customPath
        }
        return self
    }
    
    func getPath() -> UIBezierPath? {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: codeSize.width/2-offset, y: 0))
        path.addQuadCurve(to: CGPoint(x: codeSize.width/2+offset, y: 0), controlPoint: CGPoint(x: codeSize.width/2, y: -offset*2))
        path.addLine(to: CGPoint(x: codeSize.width, y: 0))
        
        path.addLine(to: CGPoint(x: codeSize.width, y: codeSize.height/2-offset))
        path.addQuadCurve(to: CGPoint(x: codeSize.width, y: codeSize.height/2+offset), controlPoint: CGPoint(x: codeSize.width+offset*2, y: codeSize.height/2))
        path.addLine(to: CGPoint(x: codeSize.width, y: codeSize.height))

        path.addLine(to: CGPoint(x: codeSize.width/2+offset, y: codeSize.height))
        path.addQuadCurve(to: CGPoint(x: codeSize.width/2-offset, y: codeSize.height), controlPoint: CGPoint(x: codeSize.width/2, y: codeSize.height-offset*2))
        path.addLine(to: CGPoint(x: 0, y: codeSize.height))

        path.addLine(to: CGPoint(x: 0, y: codeSize.height/2+offset))
        path.addQuadCurve(to: CGPoint(x: 0, y: codeSize.height/2-offset), controlPoint: CGPoint(x: offset*2, y: codeSize.height/2))
        path.addLine(to: CGPoint(x: 0, y: 0))
            
        return path
    }
}
open class SYSliderImageCodeView: UIView {

    let precision : CGFloat = 3.5  //精度
    var randomPoint : CGPoint? // 随机位置
    var seconds : CGFloat = 0
    var timer : DispatchSourceTimer?
    var imageName : String?
    var sliderWH : CGFloat = 44
    var path:UIBezierPath!
    //====================================
    public var successBlock : SliderImgCodeBlock?

    public var minimumTrackImage : UIImage? {
        didSet {
            sliderView.setMinimumTrackImage(minimumTrackImage, for: .normal)
        }
    }
    public var maximumTrackImage : UIImage?{
        didSet {
            sliderView.setMaximumTrackImage(maximumTrackImage, for: .normal)
        }
    }
    
    public var thumbImage: UIImage? {
        didSet {
            sliderView.thumbImage = thumbImage
        }
    }
    
    //显示文字
    public var text : String? {
        didSet {
            sliderView.text = text
        }
    }
   
    //控件圆角
    public var cornerRadius : CGFloat = 6 {
        didSet {
            sliderView.cornerRadius = cornerRadius
        }
    }
    
    //控件边框
    public var borderWidth : CGFloat = 1 {
        didSet {
            sliderView.borderWidth = borderWidth
        }
    }
    public var borderColor : UIColor = UIColor.grayCColor {
        didSet {
            sliderView.borderColor = borderColor
        }
    }
    
    //滑块圆角
    public var sliderCornerRadius : CGFloat = 8 {
        didSet {
            self.sliderView.sliderCornerRadius = sliderCornerRadius
        }
    }
    
    //====================================

    public init(frame: CGRect,imageName:String? = nil,sliderWH:CGFloat,pathTool:SYSliderDrawPath = SYSliderDrawPath.shared) {
        super.init(frame: frame)
        createCodeTypeImage(imageName: imageName,sliderWH: sliderWH,pathTool:pathTool)
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //创建拼图验证
    func createCodeTypeImage(imageName:String? = nil,sliderWH:CGFloat,pathTool:SYSliderDrawPath) {
        self.sliderWH = sliderWH
        self.path = pathTool.customPath
        guard let imageName = imageName else { return}
        self.imageName = imageName
        self.addSubview(mainImage)
        self.addSubview(sliderView)
        mainImage.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height-sliderWH-8)
        mainImage.image = UIImage(named: imageName)
        startShimmer()
        if path == nil {
            self.path = pathTool.getPath()
        }
        self.refreshAction()
    }
    
    //文字开始动画
    public func startShimmer() {
        sliderView.startShimmer()
    }
    //获取随机位置
    func getRandomPoint() {
        let hMax = CGFloat(mainImage.frame.height - SYSliderDrawPath.shared.codeSize.height*2)
        if SYSliderDrawPath.shared.type == .defaultType {
            let wMax = CGFloat(mainImage.frame.width - SYSliderDrawPath.shared.margin - SYSliderDrawPath.shared.codeSize.width)
            self.randomPoint = CGPoint(x:getRandomNumber(from: (SYSliderDrawPath.shared.margin+SYSliderDrawPath.shared.codeSize.width*2.0), to: wMax), y: getRandomNumber(from: (SYSliderDrawPath.shared.offset)*2, to: hMax))
        }else {
            let wMax = CGFloat(mainImage.frame.width - SYSliderDrawPath.shared.codeSize.width)
            self.randomPoint = CGPoint(x:getRandomNumber(from: (SYSliderDrawPath.shared.codeSize.width*2.0), to: wMax), y: getRandomNumber(from: 0, to: hMax))
        }
    }
    //获取一个随机整数，范围在[from, to]，包括from，包括to
    func getRandomNumber(from:CGFloat,to:CGFloat) -> CGFloat {
        return from + CGFloat(arc4random() % UInt32((to-from+1.0)))
    }
    
    public func refreshAction() {
        self.seconds = 0
        timer?.cancel()
        getRandomPoint()
        addMoveImage(self.path)
        defaultSlider()
        
        self.sliderView.setImageViewFrame(frame: CGRect(x: self.sliderView.frame.origin.x, y: (sliderWH-self.sliderView.frame.height)/2, width: sliderWH, height: sliderWH))
    }
    
    //添加可移动的图片
    func addMoveImage(_ path : UIBezierPath) {
        guard let imageName = self.imageName else { return }
        var normalImage = UIImage(named:imageName)
        if SYSliderDrawPath.shared.type == .defaultType {
            normalImage = normalImage?.sy_RescaleImage(to: CGSizeMake(self.frame.width-SYSliderDrawPath.shared.margin*2, frame.height-sliderWH-8))
        }else {
            normalImage = normalImage?.sy_RescaleImage(to: CGSizeMake(self.frame.width, frame.height-sliderWH-8))
        }
        self.mainImage.image = normalImage
        if let randomPoint = self.randomPoint {
            self.mView.frame = CGRect(x: randomPoint.x, y: randomPoint.y, width: SYSliderDrawPath.shared.codeSize.width, height: SYSliderDrawPath.shared.codeSize.height)
            self.mainImage.addSubview(mView)
            var thumbImage = self.mainImage.image?.sy_subImageWithRect(rect: self.mView.frame)
            thumbImage = thumbImage?.sy_ClipImageWithPath(path: path, mode: .scaleToFill)
            
            if let randomPoint = self.randomPoint {
                if SYSliderDrawPath.shared.type == .defaultType {
                    self.moveImage.frame = CGRect(x: 0, y: randomPoint.y-SYSliderDrawPath.shared.offset, width: SYSliderDrawPath.shared.codeSize.width+SYSliderDrawPath.shared.offset, height: SYSliderDrawPath.shared.codeSize.height+SYSliderDrawPath.shared.offset)
                }else {
                    self.moveImage.frame = CGRect(x: 0, y: randomPoint.y, width: SYSliderDrawPath.shared.codeSize.width, height: SYSliderDrawPath.shared.codeSize.height)
                }
                self.moveImage.image = thumbImage
                self.mainImage.addSubview(moveImage)
                self.maskLayer.frame = CGRect(x: 0, y: 0, width: SYSliderDrawPath.shared.codeSize.width, height: SYSliderDrawPath.shared.codeSize.height)
                self.maskLayer.path = path.cgPath
                self.maskLayer.strokeColor = UIColor.white.cgColor
                self.mView.layer.addSublayer(maskLayer)
            }
            
        }
    
    }
    func defaultSlider() {
        sliderView.value = 0.05
        changeSliderWithVlue(value: CGFloat(sliderView.value))
    }
    //图片位置随着Slider滑动改变frame
    func changeSliderWithVlue(value:CGFloat) {
        var rect = moveImage.frame
        let x: CGFloat = value * (mainImage.frame.size.width) - (value * SYSliderDrawPath.shared.codeSize.width)
        rect.origin.x = x
        moveImage.frame = rect
    }
    
    func successShow() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            DispatchQueue.main.async {
                var tip = ""
                if self.seconds > 0 {
                    tip = String(format: "耗时%.1fs", self.seconds/1000.0)
                }
                self.successBlock?(tip)
            }
        }
    }
    
    @objc func buttonAction(slider:UISlider,event:UIEvent) {
        let phase = event.allTouches?.first?.phase
        if let phase = phase {
            if phase == .began {
                let global = DispatchQueue.global(qos: .default)
                seconds = 0
                timer = DispatchSource.makeTimerSource(flags: [], queue: global)
                timer?.schedule(deadline: .now(),repeating: .milliseconds(1),leeway: .milliseconds(0))
                timer?.setEventHandler { [weak self] in
                    guard let strongSelf = self else { return }
                    strongSelf.seconds = strongSelf.seconds + 1
                }
                timer?.resume()
            }else if phase == .ended {
                timer?.cancel()
                let x = self.mView.frame.origin.x
                if (abs(self.moveImage.frame.origin.x-x) <= precision) {
                    self.successShow()
                }else {
                    defaultSlider()
                    if (!slider.isTracking && slider.value != 1) {
                        self.sliderView.setValue(0, animated: true)
                        if slider.value > 0 {
                            self.sliderView.setMinimumTrackImage(minimumTrackImage, for: .normal)
                        }else {
                            self.sliderView.setMinimumTrackImage(maximumTrackImage, for: .normal)
                        }
                        self.sliderView.setImageViewFrame(frame: CGRect(x: self.sliderView.frame.origin.x, y: (sliderWH-self.sliderView.frame.height)/2, width: sliderWH, height: sliderWH))
                    }
                }
            }else if phase == .moved {
                if SYSliderDrawPath.shared.type == .defaultType {
                    if (slider.value>Float(self.frame.size.width-SYSliderDrawPath.shared.margin*2-SYSliderDrawPath.shared.codeSize.width)) {
                        self.sliderView.value = Float(self.frame.size.width-SYSliderDrawPath.shared.margin*2-SYSliderDrawPath.shared.codeSize.width)
                        return
                    }
                }else {
                    if (slider.value>Float(self.frame.size.width-SYSliderDrawPath.shared.codeSize.width)) {
                        self.sliderView.value = Float(self.frame.size.width-SYSliderDrawPath.shared.codeSize.width)
                        return
                    }
                }
                
                changeSliderWithVlue(value: CGFloat(slider.value))
            }
        }
        
        self.sliderView.setValue(slider.value, animated: false)
        if slider.value > 0 {
            self.sliderView.setMinimumTrackImage(minimumTrackImage, for: .normal)
        }else {
            self.sliderView.setMinimumTrackImage(maximumTrackImage, for: .normal)
        }
        self.sliderView.setImageViewCenter(point: CGPoint(x: self.sliderView.frame.origin.x+CGFloat(slider.value)*(self.sliderView.frame.width-40)+20, y: self.sliderView.frame.height/2))
    }
    
    lazy var mainImage: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode =  .scaleAspectFill
        imgView.clipsToBounds = true
        return imgView
    }()
    
    lazy var mView: UIView = {
        let mask = UIView()
        mask.alpha = 0.5
        return mask
    }()
    lazy var moveImage: UIImageView = {
        let imgView = UIImageView()
        return imgView
    }()
    lazy var maskLayer: CAShapeLayer = {
        let mask = CAShapeLayer()
        return mask
    }()
    
    lazy var sliderView: SYCheckSlider = {
        let sliderView = SYCheckSlider(frame: CGRect(x: 0, y: self.frame.height-sliderWH, width: self.frame.width, height: sliderWH))
        sliderView.addTarget(self, action: #selector(buttonAction(slider:event:)), for: .allTouchEvents)
        return sliderView
    }()
}
