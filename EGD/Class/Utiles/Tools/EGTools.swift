//
//  EGTools.swift
//  EGD
//
//  Created by jieku on 2017/5/28.
//
//

import UIKit
import AVFoundation
import Photos

class EGTools: NSObject {
    //根据类名获取类
    func swiftClassFromString(className: String) -> UIViewController! {
        if  let appName: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as! String? {
            //拼接控制器名
            let classStringName = "\(appName).\(className)"
            //将控制名转换为类
            let classType = NSClassFromString(classStringName) as? UIViewController.Type
            if let type = classType {
                let newVC = type.init()
                return newVC
            }
        }
        return nil;
    }
}

extension NSObject {
    /** 相机权限检测 */
    func cameraPermissions() -> Bool{
        let authStatus:AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
        
        switch authStatus {
        case .denied , .restricted:
            return false
        case .authorized:
            return true
        case .notDetermined:
            AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: nil)
            return true
        }
    }
    
    /** 相册权限检测 */
    func photoPermissions() -> Bool{
        let authStatus:PHAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch authStatus {
        case .denied , .restricted:
            return false
        case .authorized:
            return true
        case .notDetermined:
            let vc = UIImagePickerController()
            vc.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
            return true
        }
    }
    
    //判断手机号码格式
    func isTelNumber(num:String)->Bool{
        let mobile = "^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$"
        let  CM = "^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$"
        let  CU = "^1(3[0-2]|5[256]|8[56])\\d{8}$"
        let  CT = "^1((33|53|8[09])[0-9]|349)\\d{7}$"
        let regextestmobile = NSPredicate(format: "SELF MATCHES %@",mobile)
        let regextestcm = NSPredicate(format: "SELF MATCHES %@",CM )
        let regextestcu = NSPredicate(format: "SELF MATCHES %@" ,CU)
        let regextestct = NSPredicate(format: "SELF MATCHES %@" ,CT)
        if ((regextestmobile.evaluate(with: num) == true)
            || (regextestcm.evaluate(with: num)  == true)
            || (regextestct.evaluate(with: num) == true)
            || (regextestcu.evaluate(with: num) == true))
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    /**
     *  传入设计师提供的高度获得适配屏幕的真实高度（我们设计师提供的图片的标准是iPhone 5(@2x) : 375.0 x 667）
     *
     *  @param designHeight 设计师提供的宽度
     *
     *  @return 适配屏幕的真实宽度
     */
    
    func xmc_realWidth(_ designWidth :CGFloat) -> CGFloat {
        
        return  (designWidth * (UIScreen.main.bounds.size.width) / 375.0)
    }
    
}
