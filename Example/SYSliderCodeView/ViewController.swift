//
//  ViewController.swift
//  SYSliderCodeView
//
//  Created by bsytt on 12/26/2022.
//  Copyright (c) 2022 bsytt. All rights reserved.
//

import UIKit
import SYSliderCodeView
//屏幕宽度
let kScreenWidth = UIScreen.main.bounds.size.width
//屏幕高度
let kScreenHeight = UIScreen.main.bounds.size.height

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.addSubview(sliderView)
        sliderView.changeBlock = { [weak self] success in
            if success {
                let alertVC = UIAlertController(title: nil, message: "提示", preferredStyle: .alert)
                alertVC.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { (action) in
                    self?.sliderView.didCancel()
                }))
                alertVC.addAction(UIAlertAction(title: "确定", style: .default, handler: { (action) in

                }))
                self?.present(alertVC, animated: true, completion: nil)
            }else {
                print(1)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.sliderView.startShimmer()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    let minimumTrackImage = UIImage.createImage(imgColor: UIColor.themeColor, size: CGSize(width: kScreenWidth-30, height:40))
    let maximumTrackImage = UIImage.createImage(imgColor: UIColor(red:0.94, green:0.93, blue:0.94, alpha:1.00), size: CGSize(width: kScreenWidth-30, height: 40))
    lazy var sliderView: SYSliderCodeView = {
        let slider = SYSliderCodeView(frame: CGRect(x: 15, y: 30, width: kScreenWidth-30, height: 40),sliderWH: 40)
        slider.minimumTrackImage = minimumTrackImage
        slider.maximumTrackImage = maximumTrackImage
        slider.thumbImage = UIImage(named: "darrow")
        slider.isCornerRadius = true
        slider.cornerRadius = 8
        slider.isSliderCornerRadius = true
        slider.sliderCornerRadius = 8
        slider.text = "请按住滑块，拖动到最右边"
        return slider
    }()
    
}

