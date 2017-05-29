//
//  EGCircleCollectionViewCell.swift
//  EGD
//
//  Created by jieku on 2017/5/28.
//
//

import UIKit

class EGCircleCollectionViewCell: UICollectionViewCell {
    
    var picImageView = UIImageView.init()
    
    
    var model :EGBaseModel?{
        didSet{
            picImageView.image = UIImage(named: model?.picUrl ?? "1")
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        picImageView = UIImageView(frame: self.bounds)
        picImageView.backgroundColor = UIColor.white
        addSubview(picImageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
