//
//  EGHomeTableViewCell.swift
//  EGD
//
//  Created by jieku on 2017/5/29.
//
//

import UIKit
import SDWebImage

class EGHomeTableViewCell: UITableViewCell {
    private var iocnImageView = UIImageView.init()
    private var titleLabel = UILabel.init()
    private var subTitleLabel = UILabel.init()
    private var UserStatusView :EGStatusView?   //状态
    
    var modelSetting :EGEmergencyModel?{
        
        didSet{
            self.iocnImageView.sd_setImage(with: URL.init(string: (modelSetting?.cover_image_url)!), placeholderImage: UIImage(named: "1"))
            
            self.titleLabel.text = modelSetting?.title
            self.subTitleLabel.text  = modelSetting?.subtitle
        }
    }
    
    override init(style:UITableViewCellStyle, reuseIdentifier:String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = UITableViewCellSelectionStyle.none
        
//        iocnImageView.clipRectCorner(direction: .allCorners, cornerRadius: 8.0)
        iocnImageView.layer.masksToBounds = true
        iocnImageView.layer.cornerRadius = 8.0
        contentView.addSubview(iocnImageView)
        
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont.init(name: "PingFangSC-Regular", size: 13*ScreenScale)
        titleLabel.textAlignment = NSTextAlignment.left
        titleLabel.numberOfLines = 1
        titleLabel.sizeToFit()
        contentView.addSubview(titleLabel)

        subTitleLabel.textColor = UIColor.black
        subTitleLabel.font = UIFont.init(name: "PingFangSC-Regular", size: 16*ScreenScale)
        subTitleLabel.textAlignment = NSTextAlignment.left
        subTitleLabel.numberOfLines = 1
        subTitleLabel.sizeToFit()
        contentView.addSubview(subTitleLabel)
        
        maginSize()
        
    }
    
    func maginSize() {
        
        iocnImageView.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(10*ScreenScale)
            make.top.equalTo(contentView).offset(10*ScreenScale)
            make.width.height.equalTo(60*ScreenScale)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(iocnImageView.snp.right).offset(10*ScreenScale)
            make.top.equalTo(iocnImageView.snp.top)
        }
        
        subTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(iocnImageView.snp.right).offset(10*ScreenScale)
            make.bottom.equalTo(contentView).offset(-10*ScreenScale)
        }
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}




