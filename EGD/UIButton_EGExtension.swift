//
//  UIButton_EGExtension.swift
//  
//
//  Created by jieku on 2017/6/6.
//
//

import UIKit

class UIButton_EGExtension: UIButton {

  
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var center = self.imageView?.center
        center?.x = self.frame.size.width/2
        center?.y = (self.imageView?.frame.size.height)!/2
        
        self.imageView?.center  = center!
        
        var newFrame = self.titleLabel?.frame
        newFrame?.origin.x = 0
        newFrame?.origin.y = (self.imageView?.frame.size.height)! + 5
        newFrame?.size.width = self.frame.size.width
        
        self.titleLabel?.frame = newFrame!
        
        self.titleLabel?.textAlignment = NSTextAlignment.center
        
    }

}
