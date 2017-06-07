//
//  EGEmergencyViewController.swift
//  EGD
//
//  Created by jieku on 2017/5/28.
//
//

import UIKit
import MJExtension
import SwiftyJSON

private let EGHomeCellID = "EGHomeCellID"
class EGEmergencyViewController: UIViewController {
    
    fileprivate lazy var homeTableView : UITableView = {[unowned self] in
        let homeTableView = UITableView.init(frame: self.view.bounds, style:UITableViewStyle.plain)
        homeTableView.delegate = self
        homeTableView.dataSource = self
        homeTableView.showsVerticalScrollIndicator = false
        homeTableView.showsHorizontalScrollIndicator = false
        homeTableView.backgroundColor = UIColor.themeTbaleviewGrayColors()
        homeTableView.separatorStyle = UITableViewCellSeparatorStyle.none //去掉cell上的分割线
        homeTableView.tableFooterView = UIView.init()
        return homeTableView
        }()
    
    var modelArray : [EGBaseModel] = []
    var pageCount = -2
    var souceArray = NSMutableArray.init()
    var maxtime :String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requstDataSouce()
        view.addSubview(homeTableView)
        
        
    }
    
    deinit{
        EGLog("deinit==")
    }
}
// ===添加测试数据====
extension EGEmergencyViewController{
    func requstDataSouce() {
        let queue = OperationQueue()
        queue.addOperation { () -> Void in
            for i in 1..<4 {
                let model = EGBaseModel()
                model.picUrl = "\(i)"
                self.modelArray.append(model)
            }
        }
        queue.addOperation { () -> Void in
            self.pageCount += 1
            
            
            var params = ["a": listType.newlist,"c": "data" ,"type": EGTopType.all] as [String : Any]
            if let maxtime = self.maxtime {
                params["maxtime"] = maxtime
            }
            
            EGNetworkManager.getReqeust((EGRouter.accompanyWithHomeYou.path),params: params, success: { (sucess) in
                if var max = sucess["info"].dictionaryObject{
                    max["maxtime"]  = self.maxtime
                }
                
                if let data = sucess["list"].arrayObject {
                    self.souceArray = EGEmergencyModel.mj_objectArray(withKeyValuesArray: data)
                }
                self.homeTableView.reloadData()
            }) { (error) in
                EGLog(error)
            }
        }
    }
}

extension EGEmergencyViewController : UITableViewDelegate, UITableViewDataSource,EGActionSheetDelegate{

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
        return self.souceArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return   EGHomeTableViewCell.hyb_height(for: tableView, config: { (sourceCell) in
            guard let cell = sourceCell as?EGHomeTableViewCell else {
                return
            }
            cell.modelSetting = self.souceArray[indexPath.row] as?EGEmergencyModel
        })
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier:EGHomeCellID) as?EGHomeTableViewCell
        if cell == nil {
            cell = EGHomeTableViewCell.init(style: .default, reuseIdentifier: EGHomeCellID)
        }
        cell?.modelSetting = self.souceArray[indexPath.row] as?EGEmergencyModel
        cell?.delegate = self
        cell?.clickBlock = {[weak self]()-> Void in  //[weak self] 类似于 __weak typeof(self)  防止循环引用
            
            let actionSheet = EGActionSheetView.init(title:"", itemTitles: ["拍摄","从手机相册选择"])
            actionSheet.cancleTextColor = UIColor.black
            actionSheet.titleTextFont = k15Font
            actionSheet.itemTextFont = k18Font
            actionSheet.titleTextColor = .red
            actionSheet.itemTextColor = .black
            
            actionSheet.tag = indexPath.row
            actionSheet.delegate = self

        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        
    }
    
    func sheetViewDidSelect(index: Int, title: String, actionSheet: EGActionSheetView) {
       
        EGLog("点击:===\(index)")
        
    }
    
}

extension EGEmergencyViewController : clickCycleImageDelegate,clickTopButtonDelegate{
    
    func didCycleImageIndexPth(picModel:EGBaseModel){
        EGLog("点击了第几张图片\(String(describing: picModel.picUrl))")
        let circleController = EGCircleController()
        //        circleController.picURL =  picModel.picUrl
        self.navigationController?.pushViewController(circleController, animated: true)
    }
    
    func clickButton(tag:NSInteger){
        
       EGLog("点击了分享等按钮")
        switch tag-100 {
        case 0:
            break
        case 1:
            break
        case 2:
            break
        case 3:
            break
        default:
            break
        }
    }
}


