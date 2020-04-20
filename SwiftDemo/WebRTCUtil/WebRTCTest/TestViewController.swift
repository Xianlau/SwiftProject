//
//  TestViewController.swift
//  JimuPro
//
//  Created by Sam on 2019/10/31.
//  Copyright © 2019 UBTech. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        let view = WebRTCVideoView.init(frame: self.view.bounds)
        let manager = WebRTCManager.shareInstance
        let config = SocketConfig.default
        manager.sockitConfig =  config
        
        
        self.view.addSubview(view)
        
        
        self.view.backgroundColor = .green
        
        let closeBtn = UIButton(type: .custom)
        self.view.addSubview(closeBtn)
        closeBtn.frame = CGRect(x: 30, y: 10, width: 100, height: 50)
        closeBtn.setImage(UIImage(named: "ic_back"), for: .normal)
        closeBtn.addTarget(self, action: #selector(backBtnClick), for: .touchUpInside)

    }
    
    // MARK:- 返回按钮点击
    @objc fileprivate func backBtnClick(){
        
        self.navigationController?.popViewController(animated: false)
    }
    // MARK:- 相册按钮点击
    @objc fileprivate func photoBtnClick(){

        
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        WebRTCManager.shareInstance.disconnect()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        WebRTCManager.shareInstance.connect()
    }

}
