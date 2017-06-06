//
//  UILabel_EGExtent.swift
//  EGD
//
//  Created by jieku on 2017/6/5.
//
//

import UIKit


extension  UILabel {
    
    func setupSingleLabel(styleLabel: UILabel ,textColor:UIColor ,fontSize:CGFloat){
        styleLabel.textColor = textColor
        styleLabel.numberOfLines = 1
        styleLabel.textAlignment = NSTextAlignment.left
        styleLabel.font = UIFont.init(name: "PingFangSC-Regular", size: fontSize)
        styleLabel.sizeToFit()
    }
    
}
