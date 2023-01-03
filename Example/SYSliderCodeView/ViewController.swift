//
//  SYSliderImageCodeView.swift
//  SYSliderCodeView
//
//  Created by baoshy on 2022/12/30.
//
import UIKit
import SYSliderCodeView

//屏幕宽度
let kScreenWidth = UIScreen.main.bounds.size.width
//屏幕高度
let kScreenHeight = UIScreen.main.bounds.size.height

class ViewController: UIViewController {
    let minimumTrackImage = UIImage.createImage(imgColor: UIColor.themeColor, size: CGSize(width: kScreenWidth-30, height:40))
    
    let maximumTrackImage = UIImage.createImage(imgColor: UIColor(red:0.94, green:0.93, blue:0.94, alpha:1.00), size: CGSize(width: kScreenWidth-30, height: 40))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createSlider()
        createImgSlider()
    }
    func createSlider() {
        let sliderView = SYSliderCodeView(frame: CGRect(x: 15, y: 100, width: kScreenWidth-30, height: 40), sliderWH: 40)
        sliderView.minimumTrackImage = minimumTrackImage
        sliderView.maximumTrackImage = maximumTrackImage
        sliderView.thumbImage = UIImage(named: "darrow")
        sliderView.cornerRadius = 8
        sliderView.sliderCornerRadius = 8
        sliderView.text = "请按住滑块，拖动到最右边"
        self.view.addSubview(sliderView)
        sliderView.changeBlock = { [weak self] success in
            if success {
                let alertVC = UIAlertController(title: nil, message: "提示", preferredStyle: .alert)
                alertVC.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { (action) in
                    sliderView.didCancel()
                }))
                alertVC.addAction(UIAlertAction(title: "确定", style: .default, handler: { (action) in

                }))
                self?.present(alertVC, animated: true, completion: nil)
            }else {
                print(1)
            }
        }
    }
    
    func createImgSlider() {
        let sliderView = SYSliderImageCodeView(frame: CGRect(x: 15, y: 200, width: kScreenWidth-30, height: 200), imageName: "img", sliderWH: 40)
        sliderView.minimumTrackImage = minimumTrackImage
        sliderView.maximumTrackImage = maximumTrackImage
        sliderView.thumbImage = UIImage(named: "darrow")
        sliderView.cornerRadius = 8
        sliderView.sliderCornerRadius = 8
        sliderView.text = "拖动下方滑块完成拼图"
        self.view.addSubview(sliderView)
        sliderView.successBlock = {[weak self] tip in
            let alertVC = UIAlertController(title: "验证成功", message: tip, preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "确定", style: .default, handler: { (action) in
                sliderView.refreshAction()
            }))
            self?.present(alertVC, animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    

}

