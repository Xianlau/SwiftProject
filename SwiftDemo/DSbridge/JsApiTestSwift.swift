//
//JS调用原生方法类

import Foundation
typealias JSCallback = (String, Bool)->Void

class JsApiTestSwift: NSObject {
    
    
    var value = 10
    var feedbankHandler : JSCallback?
    var valueTimer: Timer?
    
    
    // MARK: - 同步调用H5的onMessage方法
    @objc func jimuLogin( _ arg:Any) -> Dictionary<String, Any> {
        print(arg)
        let dic: Dictionary = ["result" : "i love u", "errorCode" : 0] as [String : Any]
        
        //NotificationCenter.default.post(name: Notification.Name(rawValue: "onMessage"), object: nil)
        return dic
    }
    // MARK: - 异步调用H5的onMessage方法
    @objc func showException( _ arg:Any) -> Dictionary<String, Any> {
        print(arg)
        let dic: Dictionary = ["name" : "liudashen", "age" : 20] as [String : Any]
        
        //NotificationCenter.default.post(name: Notification.Name(rawValue: "onMessage"), object: nil)
        return dic
    }
    
    // MARK: - 测试同步方法
    //MUST use "_" to ignore the first argument name explicitly。
    @objc func testSyn( _ arg:String) -> String {
        print("js调用了原生的testSyn方法")
        return String(format:"%@[Swift sync call:%@]", arg, "test")
    }
    // MARK: - 测试异步有回调
    @objc func testAsyn( _ arg:String, handler: JSCallback) {
        print("js调用了原生的testAsyn方法")
        handler(String(format:"%@[Swift async call:%@]", arg, "test"), true)
    }
    
    // MARK: - 带有dic参数的
    @objc func testNoArgSyn( _ args:Dictionary<String, Any>) -> String{
        print("js调用了原生的testNoArgSyn方法")
        return String("带有dic参数的的方法")
    }
    
    // MARK: - 持续返回进度
    @objc func callProgress( _ args:Dictionary<String, Any> , handler: @escaping JSCallback ){
        print("js调用了原生的callProgress方法")
        feedbankHandler = handler
        valueTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(feedbackValue), userInfo: nil, repeats: true)
        
    }
    //返回进度value
    @objc func feedbackValue() {
        
        if let handler = feedbankHandler {
            if value > 0{
                handler(String(value), false)//上传中
                value -= 1
            }else {
                handler(String(value), true)//上传完成
            }
        }
    }
    

}
