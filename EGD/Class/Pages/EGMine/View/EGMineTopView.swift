//
//  EGMineTopView.swift
//  Emergency
//
//  Created by shumin.tao on 2017/5/25.
//  Copyright © 2017年 yidian. All rights reserved.
//

import UIKit
import SnapKit

protocol EClickHeadViewDelegate {
    func clickEGHeadAction(sender:UIButton)
}

class EGMineTopView: UIView {
    
    var headButton = UIButton.init(type: UIButtonType.custom)
    var doctorLabel = UILabel.init()
    var hospitalLabel = UILabel.init()
    var iconImageView = UIImageView.init()
    
    var delagate : EClickHeadViewDelegate?

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        if !self.isEqual(nil) {
            self.backgroundColor = UIColor.themeMainColors()
            
            addSubViewWithFrame(frame: frame)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension EGMineTopView {
    
    func addSubViewWithFrame(frame:CGRect)  {
        
        iconImageView.frame = self.bounds
        iconImageView.image = UIImage(named:"3")
        iconImageView.clipsToBounds = true
        iconImageView.contentMode = .scaleToFill
        iconImageView.translatesAutoresizingMaskIntoConstraints = true
        self.addSubview(iconImageView)
        
        headButton.backgroundColor = UIColor.red
        headButton.layer.masksToBounds = true
        headButton.layer.cornerRadius = 88*ScreenScale/2
             headButton.addTarget(self, action: #selector(doThings),for: UIControlEvents.touchUpOutside)
        self.addSubview(headButton)
        
        doctorLabel.backgroundColor = UIColor.clear;
        doctorLabel.textColor = UIColor.white
        doctorLabel.numberOfLines = 1
        doctorLabel.font = UIFont.systemFont(ofSize: 18.0*ScreenScale)
        doctorLabel.textAlignment = NSTextAlignment.center
        self.addSubview(doctorLabel)
        
        hospitalLabel.backgroundColor = UIColor.clear;
        hospitalLabel.textColor = UIColor.white
        hospitalLabel.numberOfLines = 1
        hospitalLabel.font = UIFont.systemFont(ofSize: 12.0*ScreenScale)
        hospitalLabel.textAlignment = NSTextAlignment.center
        self.addSubview(hospitalLabel)
        
        maginSnap()
        
    }
    func maginSnap() {
        
 
    }
    
    
    func doThings(Action:UIButton)  {
        delagate?.clickEGHeadAction(sender: Action)
    }
}
