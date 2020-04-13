//
//  Sam_SingleTon.swift
//  SwiftDemo
//
//  Created by sam   on 2019/4/30.
//  Copyright © 2019 sam  . All rights reserved.
//

import UIKit

/*
 *单例模式的实现
 *
 */

class Sam_SingleTon: NSObject {

    //方法1
    static let shareInstance = Sam_SingleTon()

    //方法二 可以销毁
    private static var _shareInstance: Sam_SingleTon?
    class func getShareInsTance() -> Sam_SingleTon{
        
        guard let instance = _shareInstance else {
            _shareInstance = Sam_SingleTon()
            return _shareInstance!
        }
        return instance
    }
    
    //销毁单利对象
    class func destroy() {
        _shareInstance = nil
    }
    
    // 私有化init方法
    /*
     *因为只有 init() 是私有的，才能防止其他对象通过默认构造函数直接创建这个类对象，确保你的单例是真正的独一无二。
     因为在 Swift 中，所有对象的构造器默认都是 public，所以需要重写你的 init 让其成为私有的。这样就保证像如下的代码编译报错，不能通过。
     *
     */
    
    
    private override init() {}
    
}
