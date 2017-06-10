//
//  EGPopMenuView.swift
//  EGD
//
//  Created by jieku on 2017/6/10.
//
//

import UIKit
//指定协议
protocol PopMenuDelegate: NSObjectProtocol{
    func didClickMenu(index: Int)
}
// 封装的弹框视图 方便 以后掉用
class EGPopMenuView: UIView {
    
    var textButton: UIButton!
    var photoButton: UIButton!
    var quoteButton: UIButton!
    var linkButton: UIButton!
    var chatButton: UIButton!
    var videoButton: UIButton!
    var backgroundView: UIView!
    var nevermindButton: UIButton!
    var centerHigh: [CGPoint]!
    var centerLow: [CGPoint]!
    var centerMenu: [CGPoint]!
   weak var delegate: PopMenuDelegate?
    var isHidding: Bool = false
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initImageView()
        initCenterArray(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initCenterArray(frame: CGRect){
        let widthUnit = frame.width/4
        let heightHigh = frame.origin.y - textButton.frame.height/2
        let heightLow = frame.height + textButton.frame.height/2
        let gap = textButton.frame.height/2 + 5
        centerHigh = [CGPoint]()
        centerHigh.append(CGPoint(x: widthUnit, y: heightHigh))
        centerHigh.append(CGPoint(x: widthUnit*2, y: heightHigh))
        centerHigh.append(CGPoint(x: widthUnit*3, y: heightHigh))
        
        centerLow = [CGPoint]()
        centerLow.append(CGPoint(x: widthUnit, y: heightLow))
        centerLow.append(CGPoint(x: widthUnit*2, y: heightLow))
        centerLow.append(CGPoint(x: widthUnit*3, y: heightLow))
        centerLow.append(CGPoint(x: widthUnit*2, y: frame.height + nevermindButton.frame.height/2))
        
        centerMenu = [CGPoint]()
        centerMenu.append(CGPoint(x: widthUnit, y: frame.height/2 - gap))
        centerMenu.append(CGPoint(x: widthUnit*2, y: frame.height/2 - gap))
        centerMenu.append(CGPoint(x: widthUnit*3, y: frame.height/2 - gap))
        centerMenu.append(CGPoint(x: widthUnit, y: frame.height/2 + gap))
        centerMenu.append(CGPoint(x: widthUnit*2, y: frame.height/2 + gap))
        centerMenu.append(CGPoint(x: widthUnit*3, y: frame.height/2 + gap))
        centerMenu.append(CGPoint(x: widthUnit*2, y: frame.height - nevermindButton.frame.height/2))
    }
    fileprivate func initImageView(){
        let image = UIImage(named: "button-chat")
        let frame = CGRect.init(x: 0, y: 0, width: (image?.size.width)!, height: (image?.size.height)!)
        textButton = UIButton(frame: frame)
        textButton.setBackgroundImage(UIImage(named: "button-text")!, for: .normal)
        
        photoButton = UIButton(frame: frame)
        photoButton.setBackgroundImage(UIImage(named: "button-photo")!, for: .normal)
        
        quoteButton = UIButton(frame: frame)
        quoteButton.setBackgroundImage(UIImage(named: "button-quote")!, for: .normal)
        
        linkButton = UIButton(frame: frame)
        linkButton.setBackgroundImage(UIImage(named: "button-link")!, for: .normal)
        
        chatButton = UIButton(frame: frame)
        chatButton.setBackgroundImage(UIImage(named: "button-chat")!, for: .normal)
        
        videoButton = UIButton(frame: frame)
        videoButton.setBackgroundImage(UIImage(named: "button-video")!, for: .normal)
        nevermindButton = UIButton(type: .system)
        nevermindButton.frame = CGRect.init(x: 0, y: 0, width: self.frame.width, height: textButton.frame.height/2)
        nevermindButton.setTitle("取消", for: .normal)
        nevermindButton.backgroundColor = UIColor.red
        backgroundView = UIView(frame: self.frame)
        
        textButton.tag = 0
        photoButton.tag = 1
        quoteButton.tag = 2
        linkButton.tag = 3
        chatButton.tag = 4
        videoButton.tag = 5
    }
    
    private func setupView(){
        self.isHidden = true
        //MARK :有时间换成高斯模糊
        backgroundView.backgroundColor = UIColor.colorWithHexAlpha(0xFFFFFF, alpha: 1.0)
        backgroundView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(handleTap(sender:))))
        
        backgroundView.isUserInteractionEnabled = true
        
        nevermindButton.isHidden = true
        nevermindButton.isUserInteractionEnabled = true
        nevermindButton.backgroundColor = UIColor.colorWithHexAlpha(0xFFFFFF, alpha: 1.0)
        nevermindButton.tintColor = UIColor.themeLightGrayColors()
        
        nevermindButton.addTarget(self, action: #selector(clickMenu(sender:)), for: .touchUpInside)
        
        textButton.addTarget(self, action: #selector(clickMenu(sender:)), for: .touchUpInside)
        photoButton.addTarget(self, action: #selector(clickMenu(sender:)), for: .touchUpInside)
        quoteButton.addTarget(self, action: #selector(clickMenu(sender:)), for: .touchUpInside)
        linkButton.addTarget(self, action: #selector(clickMenu(sender:)), for: .touchUpInside)
        chatButton.addTarget(self, action: #selector(clickMenu(sender:)), for: .touchUpInside)
        videoButton.addTarget(self, action: #selector(clickMenu(sender:)), for: .touchUpInside)
        
        
        self.addSubview(backgroundView)
        self.addSubview(textButton)
        self.addSubview(photoButton)
        self.addSubview(quoteButton)
        self.addSubview(chatButton)
        self.addSubview(linkButton)
        self.addSubview(videoButton)
        self.addSubview(nevermindButton)
    }
    
    func clickMenu(sender: AnyObject){
        let index = (sender as! UIButton).tag
        hideMenuView()
        delegate?.didClickMenu(index: index)
    }
    
    func handleTap(sender: AnyObject){
        hideMenuView()
    }
    
    private func hideMenuView(){
        if isHidding{
            return
        }
        
        isHidding = true
        nevermindButton.center = centerMenu[6]
        UIView.animate(withDuration: 0.3, delay: 0.3, options: UIViewAnimationOptions.curveEaseOut, animations: { () -> Void in
            self.nevermindButton.center = self.centerLow[3]
        }) { (finished) -> Void in
            self.nevermindButton.isHidden = true
            self.isHidding = false
        }
        
        // Photo Image
        UIView.animate(withDuration: 0.6, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1.0, options: UIViewAnimationOptions.curveEaseOut, animations: { () -> Void in
            self.photoButton.center = self.centerHigh[1]
        }) { (finished) -> Void in
            self.isHidden = true
        }
        
        // Text | Chat | Quote Image
        UIView.animate(withDuration: 0.6, delay: 0.1, usingSpringWithDamping: 0.7, initialSpringVelocity: 1.0, options: UIViewAnimationOptions.curveEaseOut, animations: { () -> Void in
            self.textButton.center = self.centerHigh[0]
            self.quoteButton.center = self.centerHigh[2]
            self.chatButton.center = self.centerHigh[1]
        }) { (finished) -> Void in
        }
        
        // Link | Video Image
        UIView.animate(withDuration: 0.6, delay: 0.2, usingSpringWithDamping: 0.7, initialSpringVelocity: 1.0, options: UIViewAnimationOptions.curveEaseOut, animations: { () -> Void in
            self.linkButton.center = self.centerHigh[0]
            self.videoButton.center = self.centerHigh[2]
        }) { (finished) -> Void in
        }
    }
    
    func showMenuView(){
        self.isHidden = false
        
        nevermindButton.center = centerLow[3]
        nevermindButton.isHidden = false
        UIView.animate(withDuration: 0.3, delay: 0.3, options: UIViewAnimationOptions.curveEaseOut, animations: { () -> Void in
            self.nevermindButton.center = self.centerMenu[6]
        }) { (finished) -> Void in
        }
        
        // Photo Image
        photoButton.center = centerLow[1]
        UIView.animate(withDuration: 0.6, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1.0, options: UIViewAnimationOptions.curveEaseOut, animations: { () -> Void in
            self.photoButton.center = self.centerMenu[1]
        }) { (finished) -> Void in
        }

        //Text
        textButton.center = centerLow[0]
        quoteButton.center = centerLow[2]
        chatButton.center = centerLow[1]
        UIView.animate(withDuration: 0.6, delay: 0.1, usingSpringWithDamping: 0.7, initialSpringVelocity: 1.0, options: UIViewAnimationOptions.curveEaseOut, animations: { () -> Void in
            self.textButton.center = self.centerMenu[0]
            self.quoteButton.center = self.centerMenu[2]
            self.chatButton.center = self.centerMenu[4]
        }) { (finished) -> Void in
        }
        
        //Link 
        linkButton.center = centerLow[0]
        videoButton.center = centerLow[2]
        UIView.animate(withDuration: 0.6, delay: 0.2, usingSpringWithDamping: 0.7, initialSpringVelocity: 1.0, options: UIViewAnimationOptions.curveEaseOut, animations: { () -> Void in
            self.linkButton.center = self.centerMenu[3]
            self.videoButton.center = self.centerMenu[5]
        }) { (finished) -> Void in
        }
    }
}
