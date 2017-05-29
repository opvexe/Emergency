//
//  EGSettingTableViewCell.swift
//  Emergency
//
//  Created by shumin.tao on 2017/5/23.
//  Copyright © 2017年 yidian. All rights reserved.
//

import UIKit
import SnapKit

protocol clickSwitchDelagate {
    
    func didDelegateAction(switchSender: UISwitch)
}

class EGSettingTableViewCell: UITableViewCell {
    
    var leftLabel : UILabel?
    var rightSwitch : UISwitch?
    var rightIcon :UIImageView?
    var rightLabel :UILabel?
    var leftIconImage : UIImageView?
    var delegate : clickSwitchDelagate?
    
    
    var setting :EGSettingModel?{
        didSet{
            
            if ((setting?.iconImage) != nil) {
                self.leftIconImage?.image = UIImage(named:(setting?.iconImage)!)
                self.leftIconImage?.isHidden = false
                self.leftIconImage?.snp.updateConstraints({ (make) in
                    make.width.equalTo(20*ScreenScale)
                })
            }
    
            self.leftLabel?.text = setting!.leftTitle
            self.rightLabel?.text = setting?.rightTitle
            
            if setting?.iconRightImage != nil {
                self.rightIcon?.image = UIImage(named: (setting?.iconRightImage)!)
            }
        
            if setting?.isHiddenSwitch == "1" {         //不隐藏Switch
                self.rightSwitch?.isHidden = false
            }
        }
    }
    
    override init(style:UITableViewCellStyle, reuseIdentifier:String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = UITableViewCellSelectionStyle.none
        
        self.setUpUI();
    }
    
    func setUpUI(){
        
        
        //左侧图片
        self.leftIconImage = UIImageView()
        self.leftIconImage?.contentMode = UIViewContentMode.center
        self.leftIconImage?.isHidden = true
        contentView.addSubview(self.leftIconImage!)
        
        //Cell左侧文字
        self.leftLabel = UILabel()
        self.leftLabel?.backgroundColor = UIColor.clear;
        self.leftLabel?.textColor = UIColor.black
        self.leftLabel?.font = UIFont.systemFont(ofSize: 15.0*ScreenScale)
        self.leftLabel?.textAlignment = NSTextAlignment.left
        self.leftLabel?.sizeToFit()
        contentView .addSubview(self.leftLabel!)
        
        //按钮
        self.rightSwitch = UISwitch()
//        self.rightSwitch?.isOn = false  //设置默认值
        self.rightSwitch?.tintColor = UIColor.themeMainColors()
        self.rightSwitch?.isHidden = true
        self.rightSwitch?.addTarget(self, action: #selector(switchDidChange), for: UIControlEvents.valueChanged)
        contentView .addSubview(self.rightSwitch!)
        
        //箭头
        self.rightIcon = UIImageView()
        self.rightIcon?.contentMode = UIViewContentMode.center
        contentView .addSubview(self.rightIcon!)
        
        //右侧文字
        self.rightLabel = UILabel()
        self.rightLabel?.backgroundColor = UIColor.clear;
        self.rightLabel?.textColor = UIColor.black
        self.rightLabel?.font = UIFont.systemFont(ofSize: 10.0*ScreenScale)
        self.rightLabel?.textAlignment = NSTextAlignment.right
        self.rightLabel?.sizeToFit()
        contentView .addSubview(self.rightLabel!)
        
        //屏幕适配
        maginSnap()
        
    }
    
    func maginSnap() {
        
        self.leftIconImage?.snp.makeConstraints({ (make) in
            make.left.equalTo(self.contentView).offset(10*ScreenScale)
            make.top.equalTo(self.contentView).offset(15*ScreenScale)
            make.bottom.equalTo(self.contentView).offset(-15*ScreenScale)
            make.width.equalTo(0)
        })
        
        
        self.leftLabel?.snp.makeConstraints({ (make) in
            make.left.equalTo(self.leftIconImage!.snp.right).offset(15.0*ScreenScale)
            make.top.equalTo(contentView).offset(15*ScreenScale)
            make.bottom.equalTo(self.contentView).offset(-15*ScreenScale)
            
        })
        
        self.rightSwitch?.snp.makeConstraints({ (make) in
            make.top.equalTo(self.contentView).offset(7.0*ScreenScale)
            make.right.equalTo(self.contentView).offset(-30*ScreenScale)
            make.width.equalTo(30*ScreenScale)
            make.bottom.equalTo(self.contentView).offset(-7*ScreenScale)
        })
        
        self.rightIcon?.snp.makeConstraints({ (make) in
            make.top.equalTo(self.contentView).offset(15.0*ScreenScale)
            make.right.equalTo(self.contentView).offset(-10.0*ScreenScale)
            make.width.equalTo(20.0*ScreenScale)
            make.bottom.equalTo(self.contentView).offset(-15*ScreenScale)
        })
        
        
        self.rightLabel?.snp.makeConstraints({ (make) in
            make.right.equalTo(self.contentView).offset(-15.0*ScreenScale)
            make.top.equalTo(self.contentView).offset(15.0*ScreenScale)
            make.bottom.equalTo(self.contentView).offset(-15*ScreenScale)
        })
    }
    
    
    //点击switch事件   clickSwitchDelagate
    func switchDidChange(sender:UISwitch) {
         delegate?.didDelegateAction(switchSender: sender)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
