//
//  EGTabBarController.swift
//  Emergency
//
//  Created by shumin.tao on 2017/5/24.
//  Copyright © 2017年 yidian. All rights reserved.
//

import UIKit

class EGTabBarController: UITabBarController ,UITabBarControllerDelegate{
    
    fileprivate lazy var addBtn:UIButton = {
        var btn = UIButton.init(type: UIButtonType.custom)
        let width = kMainBoundsWidth/5
        btn.frame = CGRect(x: 2*width, y: 0, width: width, height: 49)
        btn .setBackgroundImage(UIImage(named: "tabbar_compose_button"), for: .normal)
        btn.setBackgroundImage(UIImage(named: "tabbar_compose_button_highlighted"), for: .highlighted)
        btn.setImage(UIImage(named: "tabbar_compose_icon_add"), for: UIControlState.normal)
        btn.setImage(UIImage(named: "tabbar_compose_icon_add_highlighted"), for: UIControlState.highlighted)
        btn.addTarget(self, action: #selector(addClick), for: .touchUpInside)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addChildViewControllers()
        tabBarBackgroud()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBar.addSubview(addBtn)
    }
    //点击拍视频
   @objc fileprivate func addClick() {
    let statuscontroller = EGStatusViewController()
    let customVc = EGNavigationController(rootViewController:statuscontroller)
    present(customVc, animated: true, completion: nil)
    }
    
    //添加TabBar背景颜色
   fileprivate func tabBarBackgroud() {
        let backView = UIView(frame: CGRect(x: 0, y: 0, width: kMainBoundsWidth, height: 49))
        backView.backgroundColor = UIColor.white
        tabBar.insertSubview(backView, at: 0)
        tabBar.isOpaque = true
    }
    
   fileprivate func addChildViewControllers() {
        setupOneChildViewController("陪你", image: "home_tabbar_22x22_", selectedImage: "home_tabbar_press_22x22_", controller: EGEmergencyViewController.init())
         setupOneChildViewController("视频", image: "video_tabbar_22x22_", selectedImage: "video_tabbar_press_22x22_", controller: EGVideoViewController.init())
         setupOneChildViewController("直播", image: "newcare_tabbar_22x22_", selectedImage: "newcare_tabbar_press_22x22_", controller: EGLivingShowViewController.init())
        setupOneChildViewController("我的", image: "mine_tabbar_22x22_", selectedImage: "mine_tabbar_press_22x22_", controller: EGMineViewController.init())
    }
    
    /// 添加一个子控制器
    fileprivate func setupOneChildViewController(_ title: String, image: String, selectedImage: String, controller: UIViewController) {
        
        controller.tabBarItem.title = title
        controller.title = title
        
        controller.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.themeLightGrayColors()], for: UIControlState.normal)
        controller.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.red], for: UIControlState.selected)
        
        controller.tabBarItem.image = UIImage(named: image)?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        controller.tabBarItem.selectedImage = UIImage(named: selectedImage)?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        
        let naviController = EGNavigationController.init(rootViewController: controller)
        addChildViewController(naviController)
        
    }
}
