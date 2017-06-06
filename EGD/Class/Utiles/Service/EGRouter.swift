//
//  EGRouter.swift
//  EGD
//
//  Created by jieku on 2017/5/30.
//
//

//http://www.jianshu.com/p/11f5b818cbfe

import UIKit

enum EGRouter {
    case accompanyWithHomeYou       //陪你首页
    case videoDetail            //视频
    case livingShow             //直播
    
    var path :String{  //方法可以声明为mutating。这样就允许改变隐藏参数self的case值了。
        switch self {
        case .accompanyWithHomeYou:
            return ServiceApi.getAccompanyHome_API()
            
        default:
            return ServiceApi.getAccompanyHome_API()
        }
    }

    
}
