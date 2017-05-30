//
//  EGNavigationController.swift
//  Emergency
//
//  Created by shumin.tao on 2017/5/24.
//  Copyright © 2017年 yidian. All rights reserved.
//

import UIKit

class EGNavigationController: UINavigationController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         UINavigationBar.appearance().barTintColor = UIColor.red //背景颜色
        // 设置naviBar背景图片
//        UINavigationBar.appearance().setBackgroundImage(UIImage.init(named: ""), for: UIBarMetrics.default)
        //MARK: 设置title的字体及字体颜色
         UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white, NSFontAttributeName: UIFont.systemFont(ofSize: 16*ScreenScale)]
    }
    
    // MARK: - 拦截push控制器
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        print(self.viewControllers.count)
        
        if self.viewControllers.count > 0  {
            viewController.hidesBottomBarWhenPushed = true
            viewController.navigationItem.leftBarButtonItem = setBackBarButtonItem()
        }
        super.pushViewController(viewController, animated: true)
    }
    
    //返回按钮
    func setBackBarButtonItem() -> UIBarButtonItem {
        
        let backButton = UIButton.init(type: .custom)
        backButton.setImage(UIImage(named: "leftbackicon_white_titlebar_24x24_"), for: .normal)
        backButton.sizeToFit()
        backButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        backButton.addTarget(self, action: #selector(EGNavigationController.backClick), for: .touchUpInside)
        return UIBarButtonItem.init(customView: backButton)
    }
    
 
    /// 返回
    func backClick() {
        self.popViewController(animated: true)
    }
    
    //状态栏
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}
