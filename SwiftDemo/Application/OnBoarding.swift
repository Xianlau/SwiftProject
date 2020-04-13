//
//  OnBoarding.swift
//  SwiftDemo
//
//  Created by sam   on 2020/4/7.
//  Copyright © 2020 sam  . All rights reserved.
//

import Foundation

/// 这个类用于处理处理首次进入App的逻辑处理, 减少AppDelegate的臃肿.
/// 比如根据是否登陆进入不同的界面、注册系统服务、通用服务等。
class OnBoarding {
    
    enum State {
        case showFirstLaunchVideo
        case showGuide
        case showLogin
        case showHome
    }
    
    fileprivate var appRooter: AppRouter?
    fileprivate var currentState: State = .showHome
    
    /// 调用引接口即可进入处理登陆及界面展示等流程
    func start(with router: AppRouter) {
        appRooter = router
        processNextState()
        startAppServices()
    }
    
    /// 处理 app 的下一个状态
    func processNextState() {
        
        calculateCurrentState()
        
        switch currentState {
        case .showFirstLaunchVideo:
            playLaunchVideo()
        case .showGuide:
            showGuidePage()
        case .showLogin:
            showLoginPage()
        case .showHome:
            showHomePage()
        }
    }
    
    /// 计算当前 app 启动流程状态
    func calculateCurrentState() {
        
        let preferences = AppPreferences.shared
        
        if preferences.isFirstLaunch {
            currentState = .showFirstLaunchVideo
            
        } else if preferences.shouldShowGuide {
            currentState = .showGuide
            
        } else if !preferences.hasUserLoginBefore {
            currentState = .showLogin
        } else {
            currentState = .showHome
        }
    }
    
}

fileprivate extension OnBoarding {
    
    func playLaunchVideo() {
        let tabVC = appRooter!.rootTabVC
        appRooter!.setWindowRootViewController(tabVC)
    }
    
    private func showGuidePage() {
        
    }
    
    private func showLoginPage() {
        
    }
    
    private func showHomePage() {
        let tabVC = appRooter!.rootTabVC
        appRooter!.setWindowRootViewController(tabVC)
    }
}

//MARK: - App相应服务模块的启动

fileprivate extension OnBoarding {
    
    /// 启动App所需要的基础服务
    func startAppServices() {

        //监听网络状态
        startNetworkMonitor()
    }
    

    /// 启动网络监控服务
    private func startNetworkMonitor() {
        
    }

}
