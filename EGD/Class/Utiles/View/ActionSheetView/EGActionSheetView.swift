//
//  EGActionSheetView.swift
//  EGD
//
//  Created by jieku on 2017/6/7.
//
//

import UIKit

protocol EGActionSheetDelegate : NSObjectProtocol {
    func sheetViewDidSelect(index : Int,title : String,actionSheet : EGActionSheetView)
}

class EGActionSheetView: UIView {
    
    var didSelectIndex : ((Int,String) -> ())?
    weak var delegate : EGActionSheetDelegate?
    var contentVH : CGFloat = 0
    var contentViewY : CGFloat = 0
    var footBtnY : CGFloat = kMainBoundsHeight - kCellH - kSheetMargin
    
    //标题文字字体
    var titleTextFont : UIFont?{
        didSet{
            if let txtFont = titleTextFont {
                titleView.font = txtFont
            }
        }
    }
    
    //标题颜色,默认是darkGrayColor
    var titleTextColor : UIColor = UIColor.darkGray{
        didSet{
            titleView.textColor = titleTextColor
        }
    }
    
    //item文字字体
    var itemTextFont : UIFont?{
        didSet{
            if let txtFont = itemTextFont {
                sheetView.cellTextFont = txtFont
            }
        }
    }
    
    //item字体颜色,默认是blueColor
    var itemTextColor : UIColor = UIColor.blue{
        didSet{
            sheetView.cellTextColor = itemTextColor
        }
    }
    //取消字体颜色,默认是blueColor
    var cancleTextColor : UIColor = UIColor.blue{
        didSet{
            footerBtn.setTitleColor(cancleTextColor, for: .normal)
        }
    }
    //取消文字字体
    var cancleTextFont : UIFont?{
        didSet{
            if let txtFont = cancleTextFont {
                footerBtn.titleLabel?.font = txtFont
            }
        }
    }
    //取消按钮文字设置,默认是"取消"
    var cancleTitle : String = "取消"{
        didSet{
            footerBtn.setTitle(cancleTitle, for: .normal)
        }
    }
    
    fileprivate var dataSource : [String]?
    
    init(title: String, itemTitles: [String]){
        super.init(frame: UIScreen.main.bounds)
        
        dataSource = itemTitles
        KeyWindow.addSubview(self)
        
        addSubview(bgButton)
        addSubview(contentView)
        addSubview(footerBtn)
        contentView.addSubview(sheetView)
        
        setupStyle(title: title)
        pushWeiChatStyeSheetView()
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate lazy var bgButton : UIButton = {
        let btn = UIButton.init(frame: self.frame)
        btn.backgroundColor = UIColor.black
        btn.alpha = 0.35
        btn.addTarget(self, action: #selector(dismissSheetView), for: .touchUpInside)
        
        return btn
    }()
    
    fileprivate lazy var contentView : UIView = UIView()
    
    // 取消按钮
    fileprivate lazy var footerBtn : UIButton = {
        let btn = UIButton.init(frame: CGRect.zero)
        btn.backgroundColor = UIColor.white
        btn.setTitle(self.cancleTitle, for: .normal)
        btn.titleLabel?.font = k18Font
        btn.setTitleColor(self.cancleTextColor, for: .normal)
        btn.addTarget(self, action: #selector(dismissSheetView), for: .touchUpInside)
        
        return btn
    }()
    
    // 标题view
    fileprivate lazy var titleView : UILabel = {
        let lab = UILabel()
        lab.font = k18Font
        lab.textColor = UIColor.darkGray
        lab.backgroundColor = UIColor.white
        lab.textAlignment = .center
        
        return lab
    }()
    
    /// sheetView
    fileprivate lazy var sheetView : EGSheetView = {
        let sheet = EGSheetView.init(frame: CGRect.zero)
        sheet.delegate = self
        sheet.dataSource = self.dataSource!
        
        return sheet
    }()
    
    /// 中间空隙
    fileprivate lazy var marginView : UIView = {
        let view = UIView()
        view.backgroundColor = kSlotColor
        view.alpha = 0
        
        return view
    }()
    
    //初始化
    fileprivate func setupStyle(title: String){
        
        var titleCount = 0
        if !title.isEmpty {
            titleView.frame = CGRect.init(x: 0, y: 0, width: kMainBoundsWidth, height: kCellH)
            titleView.text = title
            contentView.addSubview(titleView)
            titleCount = 1
        }
        ///contentView高度
        contentVH = kCellH * CGFloat((dataSource!.count + titleCount))
        if contentVH > kSheetViewMaxH {
            contentVH = kSheetViewMaxH
            sheetView.tableView.isScrollEnabled = true
        } else {
            sheetView.tableView.isScrollEnabled = false
        }
        
        footBtnY += kSheetMargin
        footerBtn.frame = CGRect.init(x: 0, y: footBtnY + contentVH, width: kMainBoundsWidth, height: kCellH)
        footerBtn.setTitleColor(UIColor.black, for: .normal)
        contentViewY = kMainBoundsHeight - footerBtn.mo_height - contentVH - kSheetMargin
        contentView.frame = CGRect.init(x: footerBtn.mo_x, y: kMainBoundsHeight, width: kMainBoundsWidth, height: contentVH)
        
        var sheetY : CGFloat = 0
        var sheetHeight = contentView.frame.size.height
        if titleCount == 1 {
            sheetY = titleView.bottomY
            sheetHeight -= titleView.mo_height
        }
        sheetView.frame = CGRect.init(x: contentView.mo_x, y: sheetY, width: contentView.mo_width, height: sheetHeight)
        marginView.frame = CGRect.init(x: 0, y: kMainBoundsHeight + sheetHeight, width: kMainBoundsWidth, height: kSheetMargin)
        self.addSubview(marginView)
    }
    ///显示样式
    fileprivate func pushWeiChatStyeSheetView(){
        weak var weakSelf = self
        UIView.animate(withDuration: kPushTime, animations:{
            weakSelf?.contentView.frame = CGRect.init(x: 0, y: (weakSelf?.contentViewY)!, width: kMainBoundsWidth, height: (weakSelf?.contentVH)!)
            weakSelf?.footerBtn.frame = CGRect.init(x: 0, y: (weakSelf?.footBtnY)!, width: kMainBoundsWidth, height: kCellH)
            weakSelf?.bgButton.alpha = 0.35
            weakSelf?.marginView.frame = CGRect.init(x: 0, y: (weakSelf?.footBtnY)! - kSheetMargin, width: kMainBoundsWidth, height: kSheetMargin)
            weakSelf?.marginView.alpha = 1.0
        })
    }
    //消失样式
    fileprivate func dismissWeiChatSheetView(){
        weak var weakSelf = self
        UIView.animate(withDuration: kDismissTime, animations: {
            
            weakSelf?.contentView.frame = CGRect.init(x: 0, y: kMainBoundsHeight, width: kMainBoundsWidth, height: (weakSelf?.contentVH)!)
            weakSelf?.footerBtn.frame = CGRect.init(x: 0, y: (weakSelf?.footBtnY)! + (weakSelf?.contentVH)!, width: kMainBoundsWidth, height: kCellH)
            weakSelf?.marginView.frame = CGRect.init(x: 0, y: kMainBoundsHeight + (weakSelf?.contentView.mo_height)! + (weakSelf?.titleView.mo_height)!, width: kMainBoundsWidth, height: kSheetMargin)
            weakSelf?.bgButton.alpha = 0.0
            weakSelf?.marginView.alpha = 0.0
            
        }, completion: { (finished) in
            if finished {
                weakSelf?.contentView.removeFromSuperview()
                weakSelf?.footerBtn.removeFromSuperview()
                weakSelf?.bgButton.removeFromSuperview()
                weakSelf?.marginView.removeFromSuperview()
                weakSelf?.removeFromSuperview()
            }
        })
    }
    
    //消失样式
    func dismissSheetView(){
        dismissWeiChatSheetView()
    }
}

extension EGActionSheetView : EGSheetViewDelegate{
    func sheetViewDidSelect(index: Int, title: String) {
        if didSelectIndex != nil {
            didSelectIndex!(index,title)
        }
        delegate?.sheetViewDidSelect(index: index, title: title, actionSheet: self)
        dismissSheetView()
    }
}

