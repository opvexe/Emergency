//
//  EGSheetTableViewCell.swift
//  EGD
//
//  Created by jieku on 2017/6/7.
//
//

import UIKit


class EGSheetTableViewCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = UIColor.white
        contentView.addSubview(titleLab)
        contentView.addSubview(lineView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 标题
    lazy var titleLab : UILabel = {
        let lab = UILabel(frame: CGRect.init(x: 10, y: 0, width: kMainBoundsWidth - 10*2, height: kCellH - kLineHeight))
        lab.font = k18Font
        lab.textColor = kTitleColor
        
        return lab
    }()
    
    // 分割线
    lazy var lineView : UIView = {
        let line = UIView(frame: CGRect(x: 0, y: self.titleLab.bottomY, width: kMainBoundsWidth, height: kLineHeight))
        line.backgroundColor = kGrayLineColor
        
        return line
    }()
}
