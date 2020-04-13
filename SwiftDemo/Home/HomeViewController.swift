//
//  HomeViewController.swift
//  SwiftDemo
//
//  Created by sam   on 2020/4/7.
//  Copyright © 2020 sam  . All rights reserved.
//

import UIKit

protocol HomeRouterHandle {
    func gotoHomeSubmodule(_ submodule: HomeSubmodule, params: Dictionary<String, Any>?)
}

class HomeViewController: BaseViewController {

    private var router: HomeRouter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        router = HomeRouter.init(self)
        
        self.navigationItem.title = "home"

        let btn = UIButton.init(title: "进入", fontSize: 15, titleColor: UIColor.green)
        self.view.addSubview(btn)
        btn.frame = CGRect(x: 100, y: 100, width: 100, height: 50)
        btn.backgroundColor = UIColor.yellow
        btn.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
    }
    
    @objc private func btnClick(){
        router?.gotoHomeSubmodule(.userCenter, params: nil)
    }
}

extension HomeViewController {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let arr = [String]()
        for (index, value) in arr.enumerated() {
            print(String(index) + value)
        }
    }
    
}
