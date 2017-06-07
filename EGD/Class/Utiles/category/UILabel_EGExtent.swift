//
//  UILabel_EGExtent.swift
//  EGD
//
//  Created by jieku on 2017/6/5.
//
//

import UIKit


extension  UILabel {
    
    //MARK : class 修饰类方法  ，不修饰是实力方法
    // 单行
    func setupSingleLabel(styleLabel: UILabel ,textColor:UIColor ,fontSize:CGFloat){
        styleLabel.textColor = textColor
        styleLabel.numberOfLines = 1
        styleLabel.textAlignment = NSTextAlignment.center
        styleLabel.font = UIFont.init(name: "PingFangSC-Regular", size: fontSize)
        styleLabel.sizeToFit()
    }
    //多行
     func setupMultiLineLabel(multiLabel: UILabel,textColor:UIColor ,fontSize:CGFloat){
        multiLabel.textColor = textColor
        multiLabel.textAlignment = NSTextAlignment.left
        multiLabel.numberOfLines = 0
        multiLabel.font = UIFont.init(name: "PingFangSC-Light", size: fontSize)
        multiLabel.sizeToFit()
    }
    
}
