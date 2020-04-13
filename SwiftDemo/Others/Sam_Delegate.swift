//
//  Sam_Delegate.swift
//  SwiftDemo
//
//  Created by sam   on 2019/4/30.
//  Copyright © 2019 sam  . All rights reserved.
//

import UIKit

/*
 *代理
 *
 */

//optional 前面需要j添加@objc
@objc protocol MyDelegate : NSObjectProtocol {
    
    func loveYou(name: String)
    
    @objc optional func loveOthers()
    
}

//直接在var delegate前面加weak，编译会报错。这是因为在swift中遵守protocol的类型有很多，其中有些类型不支持weak修饰，比如struct。这里需要限制protocol的类型遵守。比如下面指定这个protocol只能由class遵守：
protocol SecondDelegate : class { //只有声明了class类型的才可以使用weak
    func eat()
}


class Sam_Delegate: NSObject {

    weak var delegate : MyDelegate?
    
    weak var delegate1 : SecondDelegate?
    
    func testDelegate() {
        if delegate != nil {
            delegate?.loveYou(name:"haha")
        }
        if delegate1 != nil {
            delegate?.loveOthers?()
        }
    }
    

}

// MARK: - delegate委托
class SamPerson :NSObject, MyDelegate, SecondDelegate {
    func loveYou(name: String) {
        print("haha")
    }
    func eat() {
        print("eat")
    }
}




