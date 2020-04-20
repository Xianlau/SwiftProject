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
    
    ///字典转模型 反射
    case Model_To_Dictionary
    
    ///反射
    case mirrorVC
    
    ///WCDB
    case WCDB_VC
    
    //WebRTC_VC
    case WebRTC_VC
    
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
            
            case .Model_To_Dictionary:
                let vc = Model_To_Dictionary.init()
                self.contextViewController?.navigationController?.pushViewController(vc, animated: true)
            
            case .mirrorVC:
                let vc = Mirror_VC.init()
                self.contextViewController?.navigationController?.pushViewController(vc, animated: true)

            
            case .WCDB_VC:
                let vc = WCDB_VC.init()
                self.contextViewController?.navigationController?.pushViewController(vc, animated: true)
            
            case .WebRTC_VC:
                let vc = WebRTC_VC.init()
                self.contextViewController?.navigationController?.pushViewController(vc, animated: true)
            
            default :
                break
        }

    }
}
