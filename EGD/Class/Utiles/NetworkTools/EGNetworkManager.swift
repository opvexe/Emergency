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

// 网络请求设置 无依赖关系
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

// 网络请求设置 有依赖关系
extension EGNetworkManager {
    
    /**
     GET 请求可以设置请求之间的依赖关系
     */
    open class func getOperationReqeust(_ path : String,params : [String : Any]?, success : successBlock?,failure : failureBlock?) {
        
        self.publicReqeustOperation(.GET, path: path, params: params, success: success, failure: failure)
        
    }
    
    /**
     POST请求方法 每个请求之间设置依赖关系
     */
    open class func postOperationReqeust(_ path : String,params : [String : Any]?, success : successBlock?,failure : failureBlock?) {
        
        self.publicReqeustOperation(.POST, path: path, params: params, success: success, failure: failure)
        
        
    }
    
    /************************  // 公共的线程同步执行网络请求任务 **************************/
    
    private class  func publicReqeustOperation(_ reqeustMethod : HTTPRequestMethod ,path : String,params : [String : Any]?, success : successBlock?,  failure : failureBlock?) {
        
        let bkManager                       = self.shared;
        
        bkManager.networkLock.lock()
        
        let operation : BlockOperation      = bkManager.publicReqeust(reqeustMethod, path: path, params: params, success: success, failure: failure)
        
        operation.completionBlock           = {[weak bkManager] () in
            bkManager!.bufferOperation.remove(operation)
        }
        
        if let lastOperation = bkManager.bufferOperation.lastObject as? BlockOperation {
            operation.addDependency(lastOperation)
        }
        
        bkManager.operationQueue.addOperation(operation)
        bkManager.bufferOperation.add(operation)
        bkManager.networkLock.unlock()
    }
}

extension EGNetworkManager {
    
    /************************  //实例化一个网络请求的任务Operation对象  **************************/
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
        SessionManager.default.session.configuration.timeoutIntervalForRequest = RequestTimeoutInterval
        let dataTask = Alamofire.request(path, method: httpMethod!, parameters: params, encoding: encodingType, headers: headerDict).responseJSON(completionHandler: { (response) in
            
            let responseResult : EGNetworkResult = EGNetworkResult()
            responseResult.statusCode            = response.response?.statusCode ?? 0
            
            if response.result.isSuccess {
                if success != nil {
                    guard response.result.value != nil else {
                        responseResult.value = [String : JSON]()
                        success!(responseResult)
                        return
                    }
                }
            } else {
                if failure != nil {
                    guard response.result.error != nil else {
                        responseResult.error = NSError(domain: "未知错误", code: 505, userInfo: nil)
                        failure?(responseResult)
                        return
                    }
                    responseResult.error = (response.result.error as NSError?)!
                    OperationQueue.main.addOperation({
                        print(responseResult.errorMsg)
                        failure?(responseResult)
                    })
                }
            }
        })
        // 缓存网络请求的Task
        self.bufferDataTasks.append(dataTask)
    }
    // 取消所有网络请求
    open class func cancelAllTasks() {
        for task in self.shared.bufferDataTasks {
            task.cancel()
        }
        EGNetworkManager.shared.bufferDataTasks.removeAll()
        EGNetworkManager.shared.operationQueue.cancelAllOperations()
    }
}

