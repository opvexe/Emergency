//
//  EGEmergencyModel.swift
//  EGD
//
//  Created by jieku on 2017/5/29.
//
//

import UIKit

//首页数据模型
class EGEmergencyModel: EGBaseModel {
    
    /// 帖子信息
    var id: String!               // 帖子id
    var type: NSNumber!            // 帖子的类型
    var text: String?               // 帖子的内容
    private var _createdAt: String? // 系统审核通过后创建帖子的时间
    
    var is_gif: NSNumber!           // 是否是gif动画
    var top_cmt = [EGComment]()     // 热门评论
    var width: NSNumber?            // 视频或图片类型帖子的宽度
    var height: NSNumber?           // 图片或视频等其他的内容的高度
    var _playcount: UInt64!         // 如果含有视频则该参数为视频的长度
    
    // 图片
    var image0: String?             // 显示在页面中的视频图片的url，小图
    var image1: String?             // 显示在页面中的视频图片的url，大图
    var image2: String?             // 显示在页面中的视频图片的url，中图
    // 视频
    var image_small: String?        // 显示在页面中的视频图片的url
    var videouri: String?           // 视频播放的url地址
   private  var _videotime: String?
    var cdn_img: String?            // 视频加载时候的静态显示的图片地址
    // 音频
    var voiceuri: String?           // 如果为音频，则为音频的播放地址
    private var _voicetime: String? // 如果为音频类帖子，则返回值为音频的时长
    var voicelength: String?        // 如果为音频则为音频的时长
    
    /// 发帖人的信息
    var user_id: String?            // 发帖人的id
    var jie_v: Int?                 // 是否是百思不得姐的认证用户
    var screen_name: String?        // 发帖人的昵称
    var profile_image: String?      // 头像的图片url地址
    
    /// 关注播放等相关的
    var repost: NSNumber?           // 转发的数量
    var comment: NSNumber?          // 帖子的被评论数量
    var cai: NSNumber?              // 踩的人数
    var ding: NSNumber?             // 顶的人数
    
   private var playfcount: NSNumber?       // 真实的播放次数？
    var hate: NSNumber?             // 踩的数量
    var bookmark: NSNumber?         // 帖子的收藏量
    var favourite: NSNumber?        // 帖子的收藏量
    var love: NSNumber?             // 收藏量
    
    
    
    //只能访问类中的变量，不能访问类中的方法（除非继承）
    var videoFrame: CGRect! {
        return calcVideoPicFrame()
    }
    //计算图片的高度
    private func calcVideoPicFrame() -> CGRect {
        
        let maxWidth = kMainBoundsWidth-20*ScreenScale
        
        var mediaHeight: CGFloat = 0
        if type != 29 {
            if type == 10 && height!.doubleValue > 360.0 {
                mediaHeight = 200.0
            } else {
                mediaHeight = maxWidth * CGFloat(height!.doubleValue) / CGFloat(width!.doubleValue)
            }
        }
        return CGRect(x: 10*ScreenScale, y: 0, width: maxWidth, height: mediaHeight)
    }
    
    override class func mj_objectClassInArray() -> [AnyHashable : Any]! {
        return ["top_cmt": EGComment.self]
    }
    
    //创建时间
    var created_at: String! {
        set {
            _createdAt = newValue
        }
        get {
            return formatCreateAt()
        }
    }
    private func formatCreateAt() -> String? {
        guard let datetime = _createdAt else { return nil }
        
        let calendar = Calendar.hw_calendar
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        guard let date = dateFormatter.date(from: datetime) else { return nil }
        
        // 今年以前
        if !date.hw_isInThisYear {
            return datetime
        }
        // 昨天
        if date.hw_isInYesterday {
            dateFormatter.dateFormat = "昨天 HH:mm:ss"
            return dateFormatter.string(from: date)
        }
        // 昨天以前
        if !date.hw_isInToday {
            dateFormatter.dateFormat = "MM-dd HH:mm:ss"
            return dateFormatter.string(from: date)
        }
        // 今天
        let components = calendar.dateComponents([.hour, .minute, .second], from: date, to: Date())
        if components.hour! > 0 {
            return "\(components.hour!)小时前"
        }
        if components.minute! > 0 {
            return "\(components.minute!)分前"
        }
        return "刚刚"
    }

    var playcount: String? {         // 播放次数
        set {
            _playcount = NumberFormatter().number(from: newValue ?? "0")?.uint64Value
        }
        get {
            if _playcount > 10000 {
                return String(format:"%.2f万次", Double(_playcount) / 10000.0)
            } else {
                return String(format:"%ld次", _playcount)
            }
        }
    }

    var videotime: String? {
        set {
            guard let time = NumberFormatter().number(from: newValue!) else { return }
            let minute = time.intValue / 60
            let second = time.intValue % 60
            _videotime = String(format:"%02d:%02d",minute, second)
        }
        get {
            return _videotime
        }
    }
    var voicetime: String? {
        set {
            guard let time = NumberFormatter().number(from: newValue!) else { return }
            let minute = time.intValue / 60
            let second = time.intValue % 60
            _voicetime = String(format:"%02d:%02d",minute, second)
        }
        get {
            return _voicetime
        }
    }
}

//评论数据模型
class EGComment: EGBaseModel{
    
    var data_id: String?
    var id: String!
    var content: String!
    var ctime: String?
    var like_count: NSNumber!
    var voiceuri: String!
    var voicetime: NSNumber!
    var user: EGUser!
    
    override class func mj_objectClassInArray() -> [AnyHashable : Any]! {
        return ["user": EGUser.self]
    }
}

//用户数据模型
class EGUser: EGBaseModel {
    
    var id: String?
    var username: String?
    var sex: String!
    var profile_image: String?
    var weibo_uid: String?
    var qq_uid: String?
    var qzone_uid: String?
    var personal_page: String?
}



