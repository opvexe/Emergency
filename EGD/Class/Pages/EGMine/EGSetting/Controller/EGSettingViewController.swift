//
//  EGSettingViewController.swift
//  Emergency
//
//  Created by shumin.tao on 2017/5/23.
//  Copyright © 2017年 yidian. All rights reserved.
//

import UIKit
import MJExtension


class EGSettingViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,clickSwitchDelagate{


    
    var setCellArray:NSMutableArray?
    var tableView = UITableView.init()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "设置"
        configCellFromDateSource()
        setupTableView()
    }
    
    
    //获取不同的Cell
    fileprivate func configCellFromDateSource() {
        let dataArray = [["leftTitle":"推送通知开关","isHiddenSwitch":"1"],
                         ["leftTitle":"修改密码","iconRightImage":"comment_arrow_icon_12x12_","className":""],
                         ["leftTitle":"系统更新","rightTitle":"当前版本号 : " + infoDictionary]]
        setCellArray = EGSettingModel.mj_objectArray(withKeyValuesArray: dataArray)
        
    }
    
    /// 创建tableView
    private func setupTableView() {
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.backgroundColor = UIColor.themeTbaleviewGrayColors()
        //tableView.separatorStyle = UITableViewCellSeparatorStyle.none  //隐藏线条
        tableView.rowHeight = 44*ScreenScale
        tableView.tableFooterView = UIView.init()
        view.addSubview(tableView)
       
    }
}
//UITableViewDelegate
    extension EGSettingViewController{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return setCellArray!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier:EGSettingCellID) as?EGSettingTableViewCell
        if cell == nil {
            cell = EGSettingTableViewCell.init(style: .default, reuseIdentifier: EGSettingCellID)
        }
        cell?.setting = setCellArray?[indexPath.row] as?EGSettingModel
        
        cell?.delegate = self
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        
    }
}

extension EGSettingViewController{
    func didDelegateAction(switchSender: UISwitch){
        EGLog("点击了开关")
    }
    
}




