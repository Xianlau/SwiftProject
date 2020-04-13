//
//  DSbridgeViewController.swift
//  SwiftDemo
//
//  Created by sam   on 2019/8/13.
//  Copyright © 2019 sam  . All rights reserved.
//

import UIKit

class DSbridgeViewController: UIViewController {

    private var webview:JMWebView = {
        let webview:JMWebView = JMWebView.init()
        return webview
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //设置webview
        setupWebview()
        
        
        //NotificationCenter.default.addObserver(self, selector: #selector(getOnMessage), name: Notification.Name(rawValue: "onMessage"), object: nil)
        
        //JS调用原生
        addJsMethod()
        
        //原生调用JS"
        nativeCallJS()
    }
    
    @objc func getOnMessage() {
        
        let dic: [String : Any] = ["result" : "i love u", "errorCode" : 0] as [String : Any]
        let jsonStr = dicToString(dic)
        //原生调用js的addValue方法, 参数是[3, 4], 返回值是value
        webview.callHandler("onMessage", arguments: [jsonStr ?? ""]) { (value) in
            
            print(value ?? "")
        }
    }
    
    // MARK: - 设置Webview
    private func setupWebview() {
        webview.frame = self.view.bounds
        self.view.addSubview(webview)
        
        #if DEBUG
        webview.setDebugMode(true)
        #endif
        
        webview.customJavascriptDialogLabelTitles(["alertTitle" : "Notification",  "alertBtn" : "OK"])
        webview.navigationDelegate = self
        
//        let baseUrl = URL.init(fileURLWithPath: Bundle.main.bundlePath)
//        let htmlPath = Bundle.main.path(forResource: "test", ofType: "html") ?? ""
//        let htmlContent = (try? String.init(contentsOfFile: htmlPath, encoding: String.Encoding.utf8)) ?? ""
//        
//        webview.loadHTMLString(htmlContent, baseURL: baseUrl)
        
        let request: URLRequest = URLRequest(url: URL(string: "http://10.10.65.26:8080/coding.html")!)
        webview.load(request)
    }
    
    // MARK: - JS调用原生
    private func addJsMethod() {
        //添加原生方法类
        webview.addJavascriptObject(JsApiTestSwift.init(), namespace: nil)
        webview.addJavascriptObject(JsApiTestSwift.init(), namespace: "swift")//增加命名空间, JS在调用的时候可以用 swift.methodName 方便管理功能模块可增强阅读
    }

    
    // MARK: - 原生调用JS
    private func nativeCallJS() {
        
        _ = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(callJS), userInfo: nil, repeats: false)
        

//
//        //原生调用js的addValue方法, 参数是[3, 4], 返回值是value
//        webview.callHandler("addValue", arguments: [3, 4]) { (value) in
//            print(value ?? "")
//        }
//        //拼接字符串
//        webview.callHandler("append", arguments: ["I", "love", "you"]) { (value) in
//            print(value ?? "")
//        }
//        //传递json
//        //let dic: Dictionary = ["name": "weixiang", "sex": "male"]
//        let jsonStr: String = dicToString(dic) ?? ""
//        webview.callHandler("showJson", arguments: [jsonStr]) { (value) in
//            print(value ?? "")
//        }
//
//        //收到result 为json
//        let dic1: Dictionary = ["name": "zhangsan", "sex": "male"]
//        let jsonStr1: String = dicToString(dic1) ?? ""
//        webview.callHandler("showResult", arguments: [jsonStr1]) { (value) in
//            print(value ?? "")
//        }
//
//        webview.callHandler("startTimer") { (value) in
//            print(value ?? "")
//        }
//
//        //带有命名空间的方法
//        webview.callHandler("syn.addValue", arguments: [5, 6]) { (value) in
//
//            print(value as Any)
//        }
//
//        //测试是否js有这个方法
//        webview.hasJavascriptMethod("addValue") { (isHas) in
//            print(isHas)
//        }
//
//        //如果H5调用了window.close方法就会监听到
//        webview.setJavascriptCloseWindowListener {
//            print("监听到关闭H5页面")
//        }
//

    }
    
    @objc func callJS() {
        let dic: [String : Any] = ["name" : "liuweixiang", "age" : 20] as [String : Any]
        let jsonStr = dicToString(dic)
        //原生调用js的addValue方法, 参数是[3, 4], 返回值是value
        webview.callHandler("showException", arguments: [jsonStr ?? ""]) { (value) in
            
            print(value ?? "")
        }
    }

}

extension DSbridgeViewController: WKNavigationDelegate {
    
    // MARK: 字典转json字符串
    func dicToString(_ dic:[String : Any]) -> String? {
        let data = try? JSONSerialization.data(withJSONObject: dic, options: [])
        let str = String(data: data!, encoding: String.Encoding.utf8)
        return str
    }
    
}
