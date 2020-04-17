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

        self.navigationItem.title = "new"
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
//
//protocol Json {
//
//}
//
//
//
//class FmdbModel: Json {
//    var a : Int = 0
//    var age : Int = 10
//    var  name: String = "wo"
//
//    // 通过反射获取对象所有有的属性和属性值
//    func values() -> [String:Any] {
//        var res = [String:Any]()
//        let obj = Mirror(reflecting:self)
//        processMirror(obj: obj, results: &res)
//        getValues(obj: obj.superclassMirror, results: &res)
//        return res
//    }
//
//    // 供上方方法（获取对象所有有的属性和属性值）调用
//    private func getValues(obj: Mirror?, results: inout [String:Any]) {
//        guard let obj = obj else { return }
//        processMirror(obj: obj, results: &results)
//        getValues(obj: obj.superclassMirror, results: &results)
//    }
//
//    // 供上方方法（获取对象所有有的属性和属性值）调用
//    private func processMirror(obj: Mirror, results: inout [String: Any]) {
//        for (_, attr) in obj.children.enumerated() {
//            if let name = attr.label {
//                // 忽略 table 和 db 这两个属性
//                if name == "table" || name == "db" {
//                    continue
//                }
//                // 忽略人为指定的属性
//                if ignoredKeys().contains(name) ||
//                    name.hasSuffix(".storage") {
//                    continue
//                }
//                results[name] = unwrap(attr.value)
//            }
//        }
//    }
//
//    // 忽略的属性（模型中不需要与数据库表进行映射的字段可以在这里发返回）
//     func ignoredKeys() -> [String] {
//         return []
//     }
//
//    //将可选类型（Optional）拆包
//    func unwrap(_ any:Any) -> Any {
//        let mi = Mirror(reflecting: any)
//        if mi.displayStyle != .optional {
//            return any
//        }
//
//        if mi.children.count == 0 { return any }
//        let (_, some) = mi.children.first!
//        return some
//    }
//
//}
//
//protocol Json {
//
//    func eat()
//}
//extension Json {
//
//    func eat(){
//        print("json eat")
//    }
//}
