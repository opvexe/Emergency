//
//  EG_FontColorDefine.swift
//  Emergency
//
//  Created by shumin.tao on 2017/5/23.
//  Copyright © 2017年 yidian. All rights reserved.
//

import UIKit

extension UIColor {
    //MARK: - 十六进制返回颜色
    class  func colorWithHex(_ hexValue:u_long) ->  UIColor{
        let red = ((Float)((hexValue & 0xFF0000) >> 16))/255.0;
        let green = ((Float)((hexValue & 0xFF00) >> 8))/255.0;
        let blue = ((Float)(hexValue & 0xFF))/255.0;
        let ResultColor = UIColor.init(colorLiteralRed: red, green: green, blue: blue, alpha: 1)
        return ResultColor
    }
    //MARK: - 十六进制与透明度返回颜色
    class  func colorWithHexAlpha(_ hexValue:u_long,alpha:CGFloat) -> UIColor {
        let red = ((Float)((hexValue & 0xFF0000) >> 16))/255.0;
        let green = ((Float)((hexValue & 0xFF00) >> 8))/255.0;
        let blue = ((Float)(hexValue & 0xFF))/255.0;
        let ResultColor = UIColor.init(colorLiteralRed: red, green: green, blue: blue, alpha: Float(alpha))
        return ResultColor
    }
    //MARK: - RGB与透明度返回颜色
    class func colorWithRGBAlpha(_ red:CGFloat,green:CGFloat,blue:CGFloat,alpha:CGFloat) -> UIColor {
        let resultColor = UIColor.init(red: red, green: green, blue: blue, alpha: alpha)
        return resultColor
    }
    
    /*****************************     UI设计原型规范  背景    static子类不能被修改   *****************************/
    
    //MARK: - 主体背景颜色
    static func themeMainColors() -> UIColor {
        let themecolor = self.colorWithHex(0x557b9a)
        return themecolor
    }
    
    //MARK: - 首页UITabbleView背景颜色
    static func themeTbaleviewGrayColors() -> UIColor {
        let themecharactercolor = self.colorWithHex(0xF5F5F5)
        return themecharactercolor
    }
    
    
    /*****************************     UI设计原型规范  字体     *****************************/

    //MARK: - 主题tabBar文字颜色
  static  func themeBottomBarTitleNormalColor() -> UIColor {
        let resultColor = self.colorWithHex(0x009FE8)
        return resultColor
    }
    
    //MARK: - 白色字体颜色
    static func themeWhitColors() -> UIColor {
        let themecharactercolor = self.colorWithHex(0xFFFFFF)
        return themecharactercolor
    }
    
    //MARK: - 黑色字体颜色
    static func themeBlackColors() -> UIColor {
        let themecharactercolor = self.colorWithHex(0x333333)
        return themecharactercolor
    }
    
    //MARK: - 灰色字体颜色
    static func themeGrayColors() -> UIColor {
        let themecharactercolor = self.colorWithHex(0x666666)
        return themecharactercolor
    }
    
    //MARK: - 浅灰色字体颜色
    static func themeLightGrayColors() -> UIColor {
        let themecharactercolor = self.colorWithHex(0x999999)
        return themecharactercolor
    }
}


