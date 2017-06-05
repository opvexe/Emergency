//
//  UILabel_EGExtent.swift
//  EGD
//
//  Created by jieku on 2017/6/5.
//
//

import UIKit

extension  UILabel {
    
    // 单行label
    func EGExtentLabel(title: String ,textColor:UIColor ,fontSize:CGFloat) -> UILabel {
        let styleLabel = UILabel.init()
        styleLabel.text = title
        styleLabel.textColor = textColor
        styleLabel.numberOfLines = 1
        styleLabel.textAlignment = NSTextAlignment.left
        styleLabel.font = UIFont.init(name: "PingFangSC-Regular", size: fontSize)
        styleLabel.sizeToFit()
        return styleLabel
    }
    
    
}
