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


/*  swift 3.0
 * public：可以访问自己模块中任何 public，被 import 到其他模块，也可以被访问
 * public:这个元素可以在其他作用域被访问 ,这个元素可以在其他作用域被继承或者override
 * internal：只能访问自己模块中任何 internal 实体，不能访问其他模块中的 internal 实体
 * 现在的 : ->private则是真正的私有，离开了这个类或者结构体的作用域外面就无法访问 == swift 3.0
 * 过去的 ：->private：顾名思义，就是私有，只能在当前源文件中使用。
 * fileprivate来显式的表明，这个元素的访问权限为文件内私有,过去的private对应现在的fileprivate
 * open :
 */
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
typealias successBlock                          = (_ data  :JSON) -> Void

// 失败的回调
typealias failureBlock                          = (_ error :AnyObject) -> Void

// 请求超时时间
let RequestTimeoutInterval                      = 10.0

/// code 码 200 操作成功
private let RETURN_OK = 200

//设置请求头
extension EGNetworkManager {
    
    fileprivate func httpReqeustHeaders() ->[String: String] {
        
        var  headers:[String: String]?
        
        headers = ["User-Agent":"iPhone 6s Plus"]
        
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

    //对象是否被销毁
    deinit {
        print("==EGNetworkManager==deinit")
    }
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
            
            guard response.result.isSuccess else {
                print("加载失败")
                failure!("加载失败" as AnyObject)
                return
            }
            if let value = response.result.value {
                let dict = JSON(value)
                //                let code = dict["code"].intValue
                //                guard code == RETURN_OK else {
                //                    print("请求错误采参数")
                //                    return
                //                }
                EGLog("网络请求数据===:\(dict)")
                success!(dict)
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


