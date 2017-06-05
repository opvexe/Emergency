//
//  EGEmergencyViewController.swift
//  EGD
//
//  Created by jieku on 2017/5/28.
//
//

import UIKit
import MJExtension

private let EGHomeCellID = "EGHomeCellID"

class EGEmergencyViewController: UIViewController {
    
    fileprivate lazy var homeTableView : UITableView = {[unowned self] in
        let homeTableView = UITableView.init(frame: self.view.bounds, style:UITableViewStyle.plain)
        homeTableView.delegate = self
        homeTableView.dataSource = self
        homeTableView.showsVerticalScrollIndicator = false
        homeTableView.showsHorizontalScrollIndicator = false
        homeTableView.backgroundColor = UIColor.themeTbaleviewGrayColors()
        homeTableView.rowHeight = 60*ScreenScale
        homeTableView.tableFooterView = UIView.init()
        return homeTableView
        }()
    
    var modelArray : [EGBaseModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addTopCyclePic()              //添加轮播图测试数据
        requstNetWork()
        view.addSubview(homeTableView)
        
        
    }
}
// ===添加测试数据====
extension EGEmergencyViewController{
    
    func addTopCyclePic() {
        for i in 1..<4 {
            let model = EGBaseModel()
            model.picUrl = "\(i)"
            modelArray.append(model)
        }
    }
    
    func requstNetWork() {
        
        EGNetworkManager.getReqeust("http://api.daydaycook.com.cn/daydaycook/recommend/getMoreThemeRecipe.do?languageId=3&mainland=1&deviceId=D83DA445-62E2-46EF-A035-779FAE071FB2&uid=172096&regionCode=156&version=2.1.1",params: nil, success: { (sucess) in
            
            EGLog(sucess)
        }) { (error) in
            
        }
    }
}

extension EGEmergencyViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        let cycleView = EGCircleView.init(frame: CGRect(x: 0, y: 64.0, width:kMainBoundsWidth , height:200*ScreenScale))
        cycleView.dataArray = modelArray
        cycleView.delegate = self
        return cycleView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 200*ScreenScale
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier:EGHomeCellID) as?EGHomeTableViewCell
        if cell == nil {
            cell = EGHomeTableViewCell.init(style: .default, reuseIdentifier: EGHomeCellID)
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        
        
    }
}

extension EGEmergencyViewController : clickCycleImageDelegate{
    func didCycleImageIndexPth(picModel:EGBaseModel){
        EGLog("点击了第几张图片\(String(describing: picModel.picUrl))")
        let circleController = EGCircleController()
//        circleController.picURL =  picModel.picUrl
        self.navigationController?.pushViewController(circleController, animated: true)
    }
}

