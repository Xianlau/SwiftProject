//
//  File.swift
//  SwiftDemo
//
//  Created by sam   on 2020/4/7.
//  Copyright © 2020 sam  . All rights reserved.
//

import Foundation

final class AppRouter {
    
    fileprivate var window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    lazy var rootTabVC: RootTabBarController = {
        let tabVC = RootTabBarController()
        return tabVC
    }()
    
    func setWindowRootViewController(_ viewController: UIViewController) {
        if window.rootViewController == nil{
            window.rootViewController = viewController
            return
        }
        window.rootViewController = viewController
    }

}
