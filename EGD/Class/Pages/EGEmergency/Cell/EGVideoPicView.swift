//
//  EGVideoPicView.swift
//  EGD
//
//  Created by jieku on 2017/6/6.
//
//

import UIKit

class EGVideoPicView: UIView {
    private var coverImageView = UIImageView.init()
    private var browsePersonLabel = UILabel.init()  //浏览
    private var videoTimeLabel = UILabel.init()
    private var openBigButton = UIButton.init(type: UIButtonType.custom)
    private var gifImageView = UIImageView.init(image: UIImage(named: "common-gif"))
    private var playVideoButton = UIButton.init(type: UIButtonType.custom)
    
    var videoModel : EGEmergencyModel?{
        didSet{
            coverImageView.image = nil
            browsePersonLabel.isHidden = true
            videoTimeLabel.isHidden = true
            playVideoButton.isHidden = true
            openBigButton.isHidden = true
            
            guard let model = videoModel else { return }
            gifImageView.isHidden = !model.is_gif.boolValue
            self.loadImageBaseOnWifi(imageName: model.image0!, type: model.type)
          

            if model.type.intValue == 31 {           // 音频
             playVideoButton.isHidden = false
             videoTimeLabel.isHidden = false
             browsePersonLabel.isHidden = false
             videoTimeLabel.text = model.voicetime
             browsePersonLabel.text = model.playcount
            } else if model.type.intValue == 41 {    // 视频
             playVideoButton.isHidden = false
             openBigButton.isHidden = false
             videoTimeLabel.text = model.videotime
             browsePersonLabel.text = model.playcount
            }

        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        if !self.isEqual(nil) {
            
            coverImageView.backgroundColor = UIColor.themeBlackColors()
            coverImageView.isUserInteractionEnabled = true
            coverImageView.contentMode = .scaleAspectFit
            coverImageView.clipsToBounds = true
            
            gifImageView.contentMode = .scaleAspectFit
            gifImageView.clipsToBounds = true
            
            videoTimeLabel.backgroundColor = UIColor.themeBlackColors()
            videoTimeLabel.setupSingleLabel(styleLabel: videoTimeLabel, textColor: UIColor.themeWhitColors(), fontSize: 12*ScreenScale)
            
            
            browsePersonLabel.backgroundColor = UIColor.themeBlackColors()
            browsePersonLabel.setupSingleLabel(styleLabel: browsePersonLabel, textColor: UIColor.themeWhitColors(), fontSize: 12*ScreenScale)
            
            playVideoButton.tag = 101
            playVideoButton.backgroundColor = UIColor.red
            playVideoButton.setImage(UIImage(named: "video-play"), for: .normal)
            playVideoButton.setImage(UIImage(named: "video-play"), for: .highlighted)
            playVideoButton.addTarget(self, action: #selector(playVideo), for: .touchUpInside)
            
            openBigButton.tag = 102
            openBigButton.setImage(UIImage(named: "see-big-picture"), for: .normal)
            openBigButton.setImage(UIImage(named: "see-big-picture"), for: .highlighted)
            openBigButton.addTarget(self, action: #selector(playVideo), for: .touchUpInside)
            
            addSubview(coverImageView)
            coverImageView.addSubview(gifImageView)
            coverImageView.addSubview(browsePersonLabel)
            coverImageView.addSubview(videoTimeLabel)
            coverImageView.addSubview(playVideoButton)
            coverImageView.addSubview(openBigButton)
            
            maginSize()
        }
    }
    //MARK :适配
    private func maginSize()  {
        
        coverImageView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        gifImageView.snp.makeConstraints { (make) in
            make.left.top.equalTo(coverImageView)
            make.width.height.equalTo(30*ScreenScale)
        }
        
        browsePersonLabel.snp.makeConstraints { (make) in
            make.right.equalTo(coverImageView.snp.right)
            make.top.equalTo(coverImageView.snp.top)
        }
        
        videoTimeLabel.snp.makeConstraints { (make) in
            make.right.equalTo(coverImageView.snp.right)
            make.top.equalTo(coverImageView.snp.bottom)
        }
        
        playVideoButton.snp.makeConstraints { (make) in
            make.center.equalTo(coverImageView);//设置父视图居中
            make.width.height.equalTo(50*ScreenScale)
        }
        
        openBigButton.snp.makeConstraints { (make) in
            make.left.right.equalTo(coverImageView)
            make.height.equalTo(40*ScreenScale)
            make.bottom.equalTo(coverImageView).offset(-40*ScreenScale)
        }
        
    }
    //MARK :事件
    func playVideo(){
        EGLog("点击了")
    }
    
    private func  loadImageBaseOnWifi(imageName: String, type:NSNumber){
        coverImageView.sd_setImage(with: URL(string: imageName), placeholderImage: nil, options: [], progress: { (receivedSize, totalSize, _) in
            
            let progress = CGFloat(receivedSize)/CGFloat(totalSize)  //加载动画
            
        }) { (_, error, _, _) in
            if type.intValue == 31 || type.intValue == 41 {     //视频音频
                self.playVideoButton.isHidden = false
            }
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
