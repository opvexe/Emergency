//
//  EGBaseModel.swift
//  Emergency
//
//  Created by shumin.tao on 2017/5/25.
//  Copyright © 2017年 yidian. All rights reserved.
//

import UIKit

//自定义TableViewCellType
enum TableViewCellType {
    case TableViewCellTypeNone
    case TableViewCellTypeImages
    case TableViewCellTypeVisitor
}

class EGBaseModel: NSObject {
    
    var cellType : TableViewCellType?  //Cell的类型
    
    
    var className : String?  //类名
    var picUrl :String?    //轮播图
}
