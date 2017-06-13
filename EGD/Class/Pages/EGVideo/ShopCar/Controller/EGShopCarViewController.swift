//
//  EGShopCarViewController.swift
//  EGD
//
//  Created by jieku on 2017/6/13.
//
//

import UIKit

class EGShopCarViewController: UIViewController {
    
    fileprivate lazy var shopcartTableView : UITableView = {[unowned self] in
        let shopcartTableView = UITableView.init(frame: CGRect.zero, style:UITableViewStyle.grouped)
        //        shopcartTableView.delegate = self
        //        shopcartTableView.dataSource = self
        shopcartTableView.showsVerticalScrollIndicator = false
        shopcartTableView.showsHorizontalScrollIndicator = false
        shopcartTableView.backgroundColor = UIColor.themeTbaleviewGrayColors()
        shopcartTableView.separatorStyle = UITableViewCellSeparatorStyle.none //去掉cell上的分割线
        shopcartTableView.rowHeight = 120*ScreenScale
        shopcartTableView.sectionFooterHeight = 10*ScreenScale
        shopcartTableView.tableHeaderView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: CGFloat.leastNormalMagnitude))
        shopcartTableView.tableFooterView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: CGFloat.leastNormalMagnitude))
        return shopcartTableView
        }()
    
    fileprivate lazy var editButtonAction : UIButton = {[unowned self] in
        let editButtonAction = UIButton.init(type: UIButtonType.custom)
        editButtonAction.frame = CGRect.init(x: 0, y: 0, width: 40*ScreenScale, height: 40*ScreenScale)
        editButtonAction.setTitle("编辑", for: UIControlState.normal)
        editButtonAction.setTitle("完成", for: UIControlState.selected)
        editButtonAction.setTitleColor(UIColor.white, for: .normal)
        editButtonAction.titleLabel?.font = UIFont.init(name: "PingFangSC-Light", size: 13*ScreenScale)
        editButtonAction.addTarget(self, action: #selector(editAction), for: .touchUpInside)
        return editButtonAction
        }()
    
    fileprivate lazy var shopcartBottomView : EGShopcartBottomView = {[unowned self] in
        let shopcartBottomView = EGShopcartBottomView()
        return shopcartBottomView
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.title = "购物车"
        
        addSubview()
        
    }
}

extension EGShopCarViewController {
    //UI
    fileprivate func addSubview() {
        let editBarButtonItem = UIBarButtonItem.init(customView: self.editButtonAction)
        self.navigationItem.rightBarButtonItem = editBarButtonItem
        
        view.addSubview(shopcartTableView)
        view.addSubview(shopcartBottomView)
        layoutSubview()
    }
    //适配
   fileprivate func layoutSubview() {
        shopcartTableView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(self.view);
            make.bottom.equalTo(self.shopcartBottomView.snp.top);
        }
        shopcartBottomView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalTo(self.view);
            make.height.equalTo(50*ScreenScale);
       }
    }
    
    func editAction() {
        print("点击")
    }
}
