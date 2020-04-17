//
//  NewViewController.swift
//  SwiftDemo
//
//  Created by sam   on 2020/4/8.
//  Copyright © 2020 sam  . All rights reserved.
//swfit 反射 模型转字典

import UIKit

class Model_To_Dictionary: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "new"
        self.view.backgroundColor = .white

        
        // 创建一个User实例对象模型
        let user1 = User()
        user1.name = "刘伟湘"
        user1.age = 100
        user1.emails = ["506299396.qq.com","111111111111.qq.com"]
        let tel1 = Telephone(title: "手机", number: "18711112222")
        let tel2 = Telephone(title: "公司座机", number: "2800034")
        user1.tels = [tel1, tel2]

        // 模型转字典
        if let model = user1.toJSONModel() {
            print(model)
        }
        /*
         *打印结果
         ["age": 100, "tels": ["item0": ["number": "18711112222", "title": "手机"], "item1": ["number": "2800034", "title": "公司座机"]], "emails": ["item0": "506299396.qq.com", "item1": "111111111111.qq.com"], "name": "刘伟湘"]
         *
         */
    }
}


class User {
    var name:String = ""
    var nickname:String?
    var age:Int?
    var emails:[String]?
    var tels:[Telephone]?
}

// 电话结构体
struct Telephone {
    var title:String   // 电话标题
    var number:String  // 电话号码
}

// 自定义一个JSON协议
protocol Sam_JSON {
    func toJSONModel() -> Any?
}

// 扩展协议方法,实现一个通用的toJSONModel方法（反射实现）
extension Sam_JSON {
    // 将模型数据转成可用的字典数据,Any表示任何类型,除了方法类型
    func toJSONModel() -> Any? {
        // 根据实例创建反射结构体Mirror
        let mirror = Mirror(reflecting: self)
        
        if mirror.children.count > 0  {
            // 创建一个空字典,用于后面添加键值对
            var result: [String:Any] = [:]

            for (idx, children) in mirror.children.enumerated() {
                let propertyNameString = children.label ?? "item\(idx)"
                let value = children.value
                // 判断value的类型是否遵循JSON协议,进行深度递归调用
                if let jsonValue = value as? Sam_JSON {
                    result[propertyNameString] = jsonValue.toJSONModel()
                }
            }
            return result
        }
        return self
    }
}

// 扩展可选类型,使其遵循JSON协议,可选类型值为nil时,不转化进字典中
extension Optional: Sam_JSON {
    func toJSONModel() -> Any? {
        if let x = self {
            if let value = x as? Sam_JSON {
                return value.toJSONModel()
            }
        }
        return nil
    }
}

// 扩展两个自定义类型,使其遵循JSON协议
extension User: Sam_JSON { }
extension Telephone: Sam_JSON { }

// 扩展Swift的基本数据类型,使其遵循JSON协议
extension String: Sam_JSON { }
extension Int: Sam_JSON { }
extension Bool: Sam_JSON { }
extension Dictionary: Sam_JSON { }
extension Array: Sam_JSON { }

