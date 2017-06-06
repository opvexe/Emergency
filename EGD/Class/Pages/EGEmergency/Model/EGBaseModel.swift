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
//数据类型参数
enum EGTopType: Int {
    case all        = 1     // 全部
    case picture    = 10    // 图片
    case word       = 29    // 段子
    case voice      = 31    // 音频
    case video      = 41    // 视频
}

enum listType: String{
    case newlist  = "newlist"
    case list     = "list"
}

class EGBaseModel: NSObject {
    
    
    var className : String?  //类名
    var picUrl :String?    //轮播图
}
