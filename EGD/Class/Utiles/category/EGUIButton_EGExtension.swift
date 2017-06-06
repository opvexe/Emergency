//
//  EGUIButton_EGExtension.swift
//  EGD
//
//  Created by jieku on 2017/6/6.
//
//

import UIKit

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
