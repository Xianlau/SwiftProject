//
//  Mirror_VC.swift
//  SwiftDemo
//
//  Created by sam   on 2020/4/15.
//  Copyright © 2020 sam  . All rights reserved.
//swfit 反射

import UIKit

class Mirror_VC: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "反射的基本使用"
        self.view.backgroundColor = .white

        
        let p = Person()
        p.name = "刘伟湘"
        p.age = 22

        let mirror:Mirror = Mirror(reflecting: p)
        
        /*
         *  1. 获取对象类型
         */
        print("获取对象类型:\(mirror.subjectType)")
        //打印结果:  获取对象类型:Person
        
        /*
         *<##>  2. 获取对象的所有属性名称和属性值
         */
        for property in mirror.children {
            let propertyNameStr = property.label!  // 属性名使用!,因为label是optional类型
            let propertyValue = property.value    // 属性的值
            print("\(propertyNameStr)的值为:\(propertyValue)")
        }
        //打印结果: name的值为:Optional("刘伟湘")  age的值为:22
        
        
    }

}

class Person{

    var name: String?
    var age: Int = 0
}
