//
//  JsonDemo.swift
//  SwiftDemo
//
//  Created by sam   on 2019/4/20.
//  Copyright © 2019 sam  . All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class JsonDemo {
    
    //    （1）比如我们有一个如下的JSON数据，表示联系人集合
    let jsonStr = "[{\"name\": \"hangge\", \"age\": 100, \"phones\": [{\"name\": \"公司\",\"number\": \"123456\"}, {\"name\": \"家庭\",\"number\": \"001\"}]}, {\"name\": \"big boss\",\"age\": 1,\"phones\": [{ \"name\": \"公司\",\"number\": \"111111\"}]}]"

    
    func testJson() {

        //    为便于测试比较，我们先将JSON格式的字符串转为Data：
        guard let jsonData = jsonStr.data(using: String.Encoding.utf8, allowLossyConversion: false) else { return  }
        
//        （2）使用JSONSerializationSwiftyJSON解析
//        比如我们要取第一条联系人的第一个电话号码，每个级别都判断就很麻烦，代码如下：
        if let userArray = try? JSONSerialization.jsonObject(with: jsonData,
                                                             options: .allowFragments) as? [[String: AnyObject]],
            let phones = userArray[0]["phones"] as? [[String: AnyObject]],
            let number = phones[0]["number"] as? String {
            // 找到电话号码
            print("第一个联系人的第一个电话号码：",number)
        }
        
//        使用SwiftyJSON解析：
//        不用担心数组越界，不用判断节点，拆包什么的，代码如下：
//        如果没取到值，还可以走到错误处理来了，打印一下看看错在哪：
        let json = try! JSON(data: jsonData)
        if let number = json[0]["phones"][0]["number"].string {
            // 找到电话号码
            print("第一个联系人的第一个电话号码：",number)
        }else {
            // 打印错误信息
            print(json[0]["phones"][0]["number"])
        }
        
//        3，获取网络数据，并使用SwiftyJSON解析
//        除了解析本地的JSON数据，我们其实更常通过url地址获取远程数据并解析。
//        （1）与URLSession结合
        //创建URL对象
        let url = URL(string:"http://www.hangge.com/getJsonData.php")
        //创建请求对象
        let request = URLRequest(url: url!)
        
        let dataTask = URLSession.shared.dataTask(with: request,
                                                  completionHandler: {(data, response, error) -> Void in
                                                    if error != nil{
                                                        print(error!)
                                                    }else{
                                                        let json = try! JSON(data: data!)
                                                        if let number = json[0]["phones"][0]["number"].string {
                                                            // 找到电话号码
                                                            print("第一个联系人的第一个电话号码：",number)
                                                        }
                                                    }
        }) as URLSessionTask
        
        //使用resume方法启动任务
        dataTask.resume()
   
    }
    
    // 与Alamofire结合
    //创建URL对象
    func test2() {
        
        let url = URL(string:"http://www.hangge.com/getJsonData.php")!
        
        Alamofire.request(url).validate().responseJSON { response in
            switch response.result.isSuccess {
            case true:
                if let value = response.result.value {
                    let json = JSON(value)
                    if let number = json[0]["phones"][0]["number"].string {
                        // 找到电话号码
                        print("第一个联系人的第一个电话号码：",number)
                    }
                }
            case false:
                print(response.result.error!)
            }
        }
        
        
    }
    
}
