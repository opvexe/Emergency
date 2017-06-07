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
    // MARK: 懒加载swift 都是以闭包的形式
    private lazy var cycleView: EGCircleView = {
        let cycleView = EGCircleView.init(frame: CGRect(x: 0, y: 64.0, width:kMainBoundsWidth , height:200*ScreenScale))
        cycleView.delegate = self
        return cycleView
    }()
    //MARK : 添加小控件 == 随便写了玩的
    fileprivate lazy var footerBtn : UIButton = {
        let footerBtn = UIButton.init(frame:CGRect(x:kMainBoundsWidth - 100, y:kMainBoundsHeight-200, width:60 , height:60))
        footerBtn.layer.masksToBounds = true
        footerBtn.layer.cornerRadius = 30
        footerBtn.backgroundColor = UIColor.red
        footerBtn.addTarget(self, action: #selector(upperTop), for: .touchUpInside)
        return footerBtn
    }()
    
    var modelArray : [EGBaseModel] = []
    var pageCount = -2
    var souceArray = NSMutableArray.init()
    var maxtime :String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requstDataSouce()  //网络请求
        view.addSubview(homeTableView)
        cycleView.dataArray = modelArray
        homeTableView.tableHeaderView = cycleView
        view.addSubview(footerBtn)
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
            
            var params = ["a": listType.list,"c": "data" ,"type": EGTopType.all] as [String : Any]
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

extension EGEmergencyViewController : UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.souceArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  EGHomeTableViewCell.hyb_height(for: tableView, config: { (sourceCell) in
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

    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView){
        footerBtn.isHidden = true
    }
    public func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        footerBtn.isHidden = true
    }
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        footerBtn.isHidden = false
    }
}

extension EGEmergencyViewController : clickCycleImageDelegate,clickTopButtonDelegate,EGActionSheetDelegate{
    //MAKR :点击回到顶部
    func upperTop() {
        homeTableView.setContentOffset(CGPoint(x:0,y:0), animated: true) //方法1
//        let indexPat = NSIndexPath.init(row: 0, section: 0)
//        homeTableView.scrollToRow(at: indexPat as IndexPath, at: UITableViewScrollPosition.bottom, animated: true)  //方法2
    }
    //MARK :轮播图代理行为
    func didCycleImageIndexPth(picModel:EGBaseModel){
        
    }
    //MARK : 点击代理行为
    func clickButton(tag:NSInteger){
        switch tag-100 {
        case 0:
            EGLog("点赞")
            break
        case 1:
            EGLog("踩")
            break
        case 2:
            EGLog("分享")
            break
        case 3:
            EGLog("评论")
            break
        default:
            break
        }
    }
    //MARK :调用相机代理行为
    func sheetViewDidSelect(index: Int, title: String, actionSheet: EGActionSheetView) {
        switch index {
        case 0:
            guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
                return EGLog("读取相机错误")
            }
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.allowsEditing = true                 //允许编辑
            imagePicker.showsCameraControls = false     //是否显示控制栏（true 可自定义）
            self.present(imagePicker, animated: true, completion: { () -> Void in
            })
            break
        case 1:
            guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
                return EGLog("读取相册错误")
            }
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            self.present(picker, animated: true, completion: {
                () -> Void in
            })
            break
        default:
            break
        }
    }
    
}
//相机代理行为
extension EGEmergencyViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    private func imagePickerController(picker: UIImagePickerController,didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        EGLog("info:\(info)")
        //        let image = info[UIImagePickerControllerOriginalImage] as! UIImage  //获取选择的原图
        
        self.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        self.dismiss(animated: true, completion: nil)
    }
}
