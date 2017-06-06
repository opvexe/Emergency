//
//  EGCommonToolsDefine.swift
//  Emergency
//
//  Created by shumin.tao on 2017/5/23.
//  Copyright © 2017年 yidian. All rights reserved.
//

import UIKit

// 打印log， 格式: [时间(精确到毫秒)][文件名(类名) 方法名]: 自定义
func EGLog<T>(_ log: T?, fileName: String = #file, methodName: String = #function, lineNumber: Int = #line) {
    
    let className = (fileName as NSString).lastPathComponent.replacingOccurrences(of: ".swift", with: "", options: String.CompareOptions.backwards, range: nil)
    
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
    let dateString = formatter.string(from: Date())
    
    #if DEBUG
        if let logMessage = log
        {
            print("\n[\(dateString)] [\(className) \(methodName)]: \n\(logMessage)")
        }
        else
        {
            print("\n[\(dateString)] [\(className) \(methodName)]: \n\(String(describing: log))")
        }
    #endif
}

//AppDelegate
let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate

//屏幕宽度，屏幕高度
let kMainBoundsHeight = UIScreen.main.bounds.size.height //屏幕的高度
let kMainBoundsWidth = UIScreen.main.bounds.size.width //屏幕的宽度

//以5s为比例缩放系数
 let ScreenScale  = (kMainBoundsWidth / 375.0)

//判断IOS7
let iOS7 = (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) ? false : true

let NavBarHeight  = (iOS7 ? 64.0 : 44.0)

let StatusBarHeight  = (iOS7 ? 20.0 : 0.0)

//获取IOS版本号
let infoDictionary = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String 

let deviceUUID = UIDevice.current.identifierForVendor?.uuid //获取设备唯一标识符 UUID
let deviceName = UIDevice.current.name  //获取设备名称
let sysName = UIDevice.current.systemName //获取系统名称 例如：iPhone OS
let sysVersion = UIDevice.current.systemVersion //获取系统版本 例如：9.2
let deviceModel = UIDevice.current.model //获取设备的型号 例如：iPhone

// 当前系统版本
let CurrentVersion = UIDevice.current.systemVersion.hashValue










