//
//  HomeRouter.swift
//  SwiftDemo
//
//  Created by sam   on 2020/4/8.
//  Copyright © 2020 sam  . All rights reserved.
//

import UIKit

enum HomeSubmodule: Int {
    
    ///图片列表 SwiftyJSON_HandyJson的使用
    case photoList
    
    ///DSBridge H5和原生的交互
    case dSBridge
    
    /// 用户中心模块
    case userCenter
    
    /// 消息中心模块
    case messageCenter
    
    /// app设置模块
    case appSettings
    
}

class HomeRouter {
    
    weak var contextViewController: HomeViewController?
    
    init(_ contextViewController: HomeViewController) {
        self.contextViewController = contextViewController
    }
}

extension HomeRouter: HomeRouterHandle {
    
    // MARK: - 跳转到相应的模块
    func gotoHomeSubmodule(_ submodule: HomeSubmodule, params: Dictionary<String, Any>?) {
        
        switch submodule {
            
            case .photoList:

                let vc = SwiftyJSON_HandyJson_VC.init()
                self.contextViewController?.navigationController?.pushViewController(vc, animated: true)
            
            case .dSBridge:
                let vc = DSbridgeViewController.init()
                self.contextViewController?.navigationController?.pushViewController(vc, animated: true)
            
            case .appSettings:
//                let vc = NewViewController.init()
//                self.contextViewController?.navigationController?.pushViewController(vc, animated: true)
                print("3")
            default :
                break
        }

    }
}
