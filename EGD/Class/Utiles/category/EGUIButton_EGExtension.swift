//
//  EGUIButton_EGExtension.swift
//  EGD
//
//  Created by jieku on 2017/6/6.
//
//

import UIKit

//重写 UIButton
class EGUIButton_EGExtension: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var center = self.imageView?.center
        center?.x = self.frame.size.width/2
        center?.y = (self.imageView?.frame.size.height)!/2
        
        self.imageView?.center  = center!
        
        var newFrame = self.titleLabel?.frame
        newFrame?.origin.x = (self.imageView?.frame.size.width)! + 5
        newFrame?.origin.y = 0
        newFrame?.size.width = self.frame.size.width
        
        self.titleLabel?.frame = newFrame!
        
        self.titleLabel?.textAlignment = NSTextAlignment.center
        
    }
}

//添加实力方法
extension UIButton{
    //设置button
    func setSharedButton(styleButton: UIButton,normalImageString: String ,selectedImageString:String ,fontSize:CGFloat) {
        styleButton.setTitleColor(UIColor.themeLightGrayColors(), for: .normal)
        styleButton.setTitleColor(UIColor.themeLightGrayColors(), for: .disabled)
        styleButton.setTitleColor(UIColor.red, for: .highlighted)
        styleButton.setTitleColor(UIColor.red, for: .selected)
        styleButton.titleLabel?.font = UIFont.init(name: "PingFangSC-Light", size: fontSize)
        styleButton.setImage(UIImage(named: normalImageString), for: .normal)
        styleButton.setImage(UIImage(named: selectedImageString), for: .highlighted)
    }
    //设置Button
     func setupButton(button: UIButton, number: NSNumber, placeholder: String) {
        let count = number.intValue
        if count > 10000 {
            button.setTitle(String(format: "%.1f万", number.floatValue / 10000.0), for: .normal)
        } else if count > 0 {
            button.setTitle(String(format: "%zd", count), for: .normal)
        } else {
            button.setTitle(placeholder, for: .normal)
        }
    }
    
}




