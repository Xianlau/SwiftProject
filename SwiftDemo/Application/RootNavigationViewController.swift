//
//  RootNavigationViewController.swift
//  SwiftDemo
//
//  Created by sam   on 2020/4/7.
//  Copyright © 2020 sam  . All rights reserved.
//

import UIKit

class RootNavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //self.navigationBar.barTintColor =  .gray
    }

    
    override func pushViewController(_ viewController:UIViewController, animated:Bool) {
        if children.count>0{
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
    }

}
