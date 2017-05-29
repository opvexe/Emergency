//
//  EGNetworkManager.swift
//  EGD
//
//  Created by jieku on 2017/5/29.
//
//

import UIKit
import Alamofire
import SwiftyJSON

// 网络请求的类型
enum HTTPRequestMethod : String {
    case GET        = "GET"
    case POST       = "POST"
    case DELETE     = "DELETE"
    case PUT        = "PUT"
    case PATCH      = "PATCH"
    case OPTIONS    = "OPTIONS"
    case HEAD       = "HEAD"
    case CONNECT    = "CONNECT"
    case TRACE      = "TRACE"
}

// 成功的回调
typealias successBlock                          = (_ data  :EGNetworkResult) -> Void

// 失败的回调
typealias failureBlock                          = (_ error :EGNetworkResult) -> Void

// 请求超时时间
let RequestTimeoutInterval                      = 10.0

// 网络请求结果处理
class EGNetworkResult: NSObject {
    
    var error : NSError = NSError(domain: "未知错误", code: 505, userInfo: nil) {
        didSet {
            errorMsg = error.localizedDescription
        }
    }
    var errorMsg : String           = "未知错误"
    var value : [String : JSON]     = [String :JSON]()
    var statusCode : Int = 200
    var data : Any?
}

//设置请求头
 extension EGNetworkManager {
    
    fileprivate func httpReqeustHeaders() ->[String: String] {
        
        var  headers:[String: String]?
        
        
        
        return headers!
    }
}

//网络请求参数设置
class EGNetworkManager: NSObject {
    //单例 static 修饰不可修改
    static var shared : EGNetworkManager = {
        let manager = EGNetworkManager()
        return manager;
    }()
    //设置队列最大并发数
    lazy var operationQueue : OperationQueue = {
        let queue                            = OperationQueue()
        queue.maxConcurrentOperationCount    = 3
        return queue
    }()
    
    // 缓存正在请求的任务
    lazy var bufferOperation : NSMutableArray = {
        let array = NSMutableArray()
        return array
    }()
    //URLSessionDataTask
    lazy var bufferDataTasks : [DataRequest] = {
        let tasks = [DataRequest]()
        return tasks
    }()
    // 线程资源锁
    lazy var networkLock : NSLock =  {
        let lock = NSLock()
        return lock
    }()
}

// 网络请求设置
 extension EGNetworkManager {
    /**
     发送一个 Post 请求
     */
    open class func postReqeust(_ path : String,params : [String : Any]?, success : successBlock?,failure : failureBlock?) {
        
        let option              = self.shared.publicReqeust(.POST, path: path, params: params, success: success, failure: failure);
        
        option.start()
        
    }
    
    /**
     发送一个 GET 请求
     */
   open class func getReqeust(_ path : String,params : [String : Any]?, success : successBlock?,failure : failureBlock?) {
        
        
        let option          = self.shared.publicReqeust(.GET, path: path, params: params, success: success, failure: failure);
        
        option.start()
        
    }
    
    
    /**
     公共的请求方法 返回一个 NSOperation
     */
    func publicReqeust(_ reqeustMethod : HTTPRequestMethod ,path : String,params : [String : Any]?, success : successBlock?,  failure : failureBlock?) -> BlockOperation {
        
        let operation           = BlockOperation {[weak self] () in
            self?.initNetworkOpeation(reqeustMethod.rawValue, path: path, params: params, success: success, failure: failure)
        }
        return operation
        
    }
}

//实例化一个网络请求的任务Operation对象
extension EGNetworkManager {
    
   fileprivate func initNetworkOpeation(_ reqeustMethod : String ,path : String,params : [String : Any]?, success : successBlock?,  failure : failureBlock?) {
    
    let headerDict = self.httpReqeustHeaders()
    print("请求URL : \n \(JSON(path))")
    if params != nil {
        print("请求参数 : \n \(JSON(params!))")
    }
    let httpMethod = HTTPMethod(rawValue: reqeustMethod)
    var encodingType =  URLEncoding.default as ParameterEncoding
    if reqeustMethod != "GET" {
        encodingType = JSONEncoding.default as ParameterEncoding
    }
     // 设置超时时间
 }
}

