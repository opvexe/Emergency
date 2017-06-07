//
//  EGHomeTableViewCell.swift
//  EGD
//
//  Created by jieku on 2017/5/29.
//
//

import UIKit
import SDWebImage

// Swift中如何定义协议: 必须遵守NSObjectProtocol
protocol clickTopButtonDelegate :NSObjectProtocol{
    func clickButton(tag:NSInteger)
}
//闭包的使用  无参无返回值
typealias blockBtnClickSendValue = ()->Void

private let EGwidth = (kMainBoundsWidth-20*ScreenScale)/4
class EGHomeTableViewCell: UITableViewCell {
    private var profileImageView = UIImageView.init()
    private var screenNameLabel = UILabel.init()
    private var createTimeLabel = UILabel.init()
    private var contentLabel = UILabel.init()
    private var moreButton = UIButton.init(type: .custom)
    private var bottomView = UIView.init()
    private var commentLabel = UILabel.init()
    //底部按钮
    private var lineImageView = UIImageView.init() //线
    private var dingButton = EGUIButton_EGExtension.init(type: .custom)
    private var caiButton = EGUIButton_EGExtension.init(type: .custom)
    private var shareButton = EGUIButton_EGExtension.init(type: .custom)
    private var commentButton = EGUIButton_EGExtension.init(type: .custom)
    //视频/图片/
    private var videoPicView  = EGVideoPicView.init()
    private var UserStatusView :EGStatusView?   //状态
    
    
    //定义一个属性保存代理,一定要加weak,避免循环引用
    weak var delegate :clickTopButtonDelegate?
    var clickBlock : blockBtnClickSendValue?
    var modelSetting :EGEmergencyModel?{
        didSet{
            profileImageView.image = nil
            screenNameLabel.text = nil
            createTimeLabel.text = nil
            contentLabel.text = nil
             videoPicView.isHidden = true
            
            guard let model = modelSetting else {
                return
            }
            //头像
            if let profileImage = model.profile_image {
                profileImageView.sd_setImage(with: URL(string: profileImage), placeholderImage: UIImage(named: "2"))
            }
            //昵称
            if let screen_name = model.screen_name {
                screenNameLabel.text = screen_name
            }
            //时间
            if let created_at = model.created_at {
                
                createTimeLabel.text = created_at
            }
            //内容
            if let text = model.text {
                contentLabel.text = text
                contentLabel.frame.size.height = contentLabel.textRect(forBounds: contentLabel.bounds, limitedToNumberOfLines: 0).size.height
            }
            // 顶
            dingButton.setupButton(button: dingButton, number: model.ding ?? 0, placeholder: "顶")
            // 踩
            caiButton.setupButton(button: caiButton, number: model.cai ?? 0, placeholder: "踩")
            // 分享
            shareButton.setupButton(button: shareButton, number: model.repost ?? 0, placeholder: "分享")
            // 评论
            commentButton.setupButton(button: commentButton, number: model.comment ?? 0, placeholder: "评论")
            
            //根据类型显示内容
            guard model.type != 29  else {
                return
            }
            
            videoPicView.videoModel = model
            videoPicView.isHidden = false
            videoPicView.snp.updateConstraints({ (make) in
                make.height.equalTo(model.videoFrame.height)
            })
        
            setNeedsLayout()
        }
    }
    
    override init(style:UITableViewCellStyle, reuseIdentifier:String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = UITableViewCellSelectionStyle.none
        self.backgroundView = UIImageView(image: UIImage(named: "mainCellBackground"))
        
        //头像
        profileImageView.layer.masksToBounds = true
        profileImageView.layer.cornerRadius = 20*ScreenScale
        //用户名
        screenNameLabel.setupSingleLabel(styleLabel: screenNameLabel, textColor: UIColor.themeBlackColors(), fontSize: 14*ScreenScale)
        //发布时间
        createTimeLabel.setupSingleLabel(styleLabel: createTimeLabel, textColor: UIColor.themeLightGrayColors(), fontSize: 12*ScreenScale)
        //更多
        moreButton.tag = 105
        moreButton.setImage(UIImage(named: "cellmorebtnnormal"), for: .normal)
        moreButton.setImage(UIImage(named: "cellmorebtnclick"), for: .highlighted)
        moreButton.addTarget(self, action: #selector(moreThings), for: .touchUpInside)
        //发布内容
        contentLabel.setupMultiLineLabel(multiLabel: contentLabel, textColor: UIColor.themeBlackColors(), fontSize: 14*ScreenScale)
        //底部bottomView
        bottomView.backgroundColor = UIColor.themeTbaleviewGrayColors()
        // 顶
        dingButton.tag = 100
        dingButton.setSharedButton(styleButton: dingButton, normalImageString: "mainCellDing", selectedImageString: "mainCellDingClick", fontSize: 12*ScreenScale)
        dingButton.addTarget(self, action: #selector(dothings), for: .touchUpInside)
        // 踩
        caiButton.tag = 101
        caiButton.setSharedButton(styleButton: caiButton, normalImageString: "mainCellCai", selectedImageString: "mainCellCaiClick", fontSize: 12*ScreenScale)
        caiButton.addTarget(self, action: #selector(dothings), for: .touchUpInside)
        // 分享
        shareButton.tag = 102
        shareButton.setSharedButton(styleButton: shareButton, normalImageString: "mainCellShare", selectedImageString: "mainCellShareClick", fontSize: 12*ScreenScale)
        shareButton.addTarget(self, action: #selector(dothings), for: .touchUpInside)
        //评论
        commentButton.tag = 103
        commentButton.setSharedButton(styleButton: commentButton, normalImageString: "mainCellComment", selectedImageString: "mainCellCommentClick", fontSize: 12*ScreenScale)
        commentButton.addTarget(self, action: #selector(dothings), for: .touchUpInside)
        
        contentView.addSubview(profileImageView)
        contentView.addSubview(screenNameLabel)
        contentView.addSubview(createTimeLabel)
        contentView.addSubview(moreButton)
        contentView.addSubview(contentLabel)
        contentView.addSubview(bottomView)
        contentView.addSubview(videoPicView)        //视频/图片/
        
        bottomView.addSubview(dingButton)
        bottomView.addSubview(caiButton)
        bottomView.addSubview(shareButton)
        bottomView.addSubview(commentButton)
        
        
        //最后一个视图
        self.hyb_lastViewInCell = bottomView
        self.hyb_bottomOffsetToCell = 10*ScreenScale
        
        maginSize()
        
    }
    //适配
    private func maginSize() {
        profileImageView.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(5*ScreenScale)
            make.top.equalTo(contentView).offset(10*ScreenScale)
            make.width.height.equalTo(40*ScreenScale)
        }
        
        screenNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(profileImageView.snp.right).offset(10*ScreenScale)
            make.top.equalTo(profileImageView.snp.top).offset(0)
        }
        
        createTimeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(profileImageView.snp.right).offset(10*ScreenScale)
            make.top.equalTo(screenNameLabel.snp.bottom).offset(5*ScreenScale)
        }
        
        moreButton.snp.makeConstraints { (make) in
            make.right.equalTo(contentView).offset(-10*ScreenScale)
            make.top.equalTo(contentView).offset(10*ScreenScale)
            make.width.height.equalTo(30*ScreenScale)
        }
        
        contentLabel.snp.makeConstraints { (make) in
            make.top.equalTo(profileImageView.snp.bottom).offset(10*ScreenScale)
            make.left.equalTo(profileImageView.snp.left)
            make.right.equalTo(contentView).offset(-5*ScreenScale)
        }
        
        videoPicView.snp.makeConstraints { (make) in
            make.left.right.equalTo(contentView)
            make.top.equalTo(contentLabel.snp.bottom).offset(10*ScreenScale)
            make.height.equalTo(0)
        }
        
        bottomView.snp.makeConstraints { (make) in
            make.left.right.equalTo(contentView).offset(0)
            make.top.equalTo(videoPicView.snp.bottom).offset(10*ScreenScale)
            make.height.equalTo(35*ScreenScale)
        }
        
        
        dingButton.snp.makeConstraints { (make) in
            make.left.equalTo(bottomView.snp.left).offset(0)
            make.top.equalTo(bottomView.snp.top).offset(10*ScreenScale)
            make.bottom.equalTo(bottomView.snp.bottom).offset(-10*ScreenScale)
            make.width.equalTo(EGwidth)
        }
        
        caiButton.snp.makeConstraints { (make) in
            make.left.equalTo(dingButton.snp.right).offset(0)
            make.top.equalTo(bottomView.snp.top).offset(10*ScreenScale)
            make.bottom.equalTo(bottomView.snp.bottom).offset(-10*ScreenScale)
            make.width.equalTo(EGwidth)
        }
        
        shareButton.snp.makeConstraints { (make) in
            make.left.equalTo(caiButton.snp.right).offset(0)
            make.top.equalTo(bottomView.snp.top).offset(10*ScreenScale)
            make.bottom.equalTo(bottomView.snp.bottom).offset(-10*ScreenScale)
            make.width.equalTo(EGwidth)
        }
        
        commentButton.snp.makeConstraints { (make) in
            make.left.equalTo(shareButton.snp.right).offset(0)
            make.top.equalTo(bottomView.snp.top).offset(10*ScreenScale)
            make.bottom.equalTo(bottomView.snp.bottom).offset(-10*ScreenScale)
            make.width.equalTo(EGwidth)
        }
        
    }
    
    //代理方法
    func dothings(sender:UIButton) {
     delegate?.clickButton(tag: sender.tag)
    }
    //闭包方法
    func moreThings() {
        guard (clickBlock != nil) else {
            return
        }
        clickBlock!()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //重写frame
    override var frame: CGRect{
        didSet {
            var newFrame = self.frame
            newFrame.size.height -= 10*ScreenScale
            newFrame.origin.y += 10*ScreenScale
            newFrame.origin.x += 10*ScreenScale
            newFrame.size.width -= 20*ScreenScale
            super.frame = newFrame
        }
    }
}




