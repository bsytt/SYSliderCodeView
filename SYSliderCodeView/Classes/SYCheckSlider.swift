//
//  CheckSlider.swift
//  SYRadarView
//
//  Created by baoshy on 2022/12/22.
//

import UIKit

class SYCheckSlider: UISlider {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
    }
}
