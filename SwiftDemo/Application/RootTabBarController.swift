//
//  RootTabBarController.swift
//  SwiftDemo
//
//  Created by sam   on 2020/4/7.
//  Copyright © 2020 sam  . All rights reserved.
//

import UIKit

class RootTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        setupUI()
        creatSubViewControllers()
    }
    
    func setupUI(){
        
        let color: UIColor = .white
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor : color], for: UIControl.State.selected)
        self.tabBar.barTintColor = .darkGray
    }
    
    func creatSubViewControllers(){
        let vc1  = HomeViewController ()
        let navc1 = RootNavigationViewController(rootViewController: vc1)
        
        let item1 : UITabBarItem = UITabBarItem (title: "第一页面", image: UIImage(named: "ic_action_normal")?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "ic_action_normal")?.withRenderingMode(.alwaysOriginal))
        navc1.tabBarItem = item1
        
        let vc2 = HomeViewController()
        let navc2 = RootNavigationViewController(rootViewController: vc2)
        let item2 : UITabBarItem = UITabBarItem (title: "第二页面", image: UIImage(named: "ic_mechanical_normal")?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "ic_mechanical_normal")?.withRenderingMode(.alwaysOriginal))
        navc2.tabBarItem = item2
        
        let vc3 = HomeViewController()
        let navc3 = RootNavigationViewController(rootViewController: vc3)
        let item3 : UITabBarItem = UITabBarItem (title: "第三页面", image: UIImage(named: "ic_letter_normal")?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "ic_letter_normal")?.withRenderingMode(.alwaysOriginal))
        navc3.tabBarItem = item3
        
        let tabArray = [navc1, navc2, navc3]
        self.viewControllers = tabArray
    }
}
