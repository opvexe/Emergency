//
//  EGVideoCollectionViewCell.swift
//  EGD
//
//  Created by jieku on 2017/6/9.
//
//

import UIKit
import SDWebImage

class EGVideoCollectionViewCell: UICollectionViewCell {
    
    fileprivate var shopImageView = UIImageView.init()
    fileprivate var priceLabel = UILabel.init()
    var model: EGShopModel?{
        didSet{
            shopImageView.sd_setImage(with: URL.init(string: (model?.img)!), placeholderImage: UIImage.init(named: "icon_avatar"))
            priceLabel.text = model?.price
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        shopImageView.contentMode = .scaleAspectFit
        shopImageView.clipsToBounds = true
        
        priceLabel.setupSingleLabel(styleLabel: priceLabel, textColor: UIColor.themeWhitColors(), fontSize: 15*ScreenScale)
        priceLabel.backgroundColor = UIColor.colorWithHexAlpha(0x333333, alpha: 0.8)
        priceLabel.layer.masksToBounds = true
        priceLabel.layer.cornerRadius = 4.0
        
        addSubview(shopImageView)
        addSubview(priceLabel)
        
        maginSnap()
    }
    fileprivate func maginSnap()  {
        
        shopImageView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        priceLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(shopImageView)
            make.bottom.equalTo(shopImageView.snp.bottom).offset(-10*ScreenScale)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
