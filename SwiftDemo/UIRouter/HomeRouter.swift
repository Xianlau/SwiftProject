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
    
    ///人脸识别
    case faceRecognition
    
    //["alamofire + moya + HandyJson使用", "DSBridge H5和原生的交互", "反射_基本用法" ,"反射_模型转字典", "WCDB数据库", "WebRTC 音视频直播"]
    var modualDescribtion : String {
        switch self {
        case .photoList:
           return "alamofire + moya + HandyJson使用"
            
            case .dSBridge:
               return "DSBridge H5和原生的交互"
            
            case .Model_To_Dictionary:
               return "反射_模型转字典"
            
            case .mirrorVC:
               return "反射_基本用法"
            
            case .WCDB_VC:
               return "WCDB数据库"
            
            case .WebRTC_VC:
               return "WebRTC 音视频直播"
            
            case .faceRecognition:
               return "人脸识别"
        }
    }
    
    static let count = 7
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
            
            case .faceRecognition:
                let vc = FaceDetectionViewController.init()
                self.contextViewController?.navigationController?.pushViewController(vc, animated: true)
            
            default :
                break
        }

    }
}
