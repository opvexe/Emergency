//
//  EGHomeTableViewCell.swift
//  EGD
//
//  Created by jieku on 2017/5/29.
//
//

import UIKit

class EGHomeTableViewCell: UITableViewCell {
    private var iocnImageView : UIImageView?
    private var nameLabel : UILabel?
    private var signatureLabel :UILabel?        //个签
    private var pushTimeLabel :UILabel?         //时间
    private var helloButton :UIButton?          //撩他
    private var UserStatusView :EGStatusView?   //状态

    override init(style:UITableViewCellStyle, reuseIdentifier:String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = UITableViewCellSelectionStyle.none
        
        
        showUI()
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension EGHomeTableViewCell {
    
    func showUI(){
        
        
        
    }
    
}



