//
//  PostAndGet.swift
//  SwiftDemo
//
//  Created by sam   on 2019/4/23.
//  Copyright © 2019 sam  . All rights reserved.
//

import Foundation

/*
 *网络请求
 *
 */

class PostAndGet {
    
    
    func GET1(){
        let url: URL = URL(string: "http://120.25.226.186:32812/login?username=520it&pwd=520it&type=JSON")!
        //请求对象内部默认已经包含了请求头和请求方法（GET）
        let request: URLRequest = URLRequest(url: url)
        //3.获得会话对象
        let session: URLSession = URLSession.shared

        //4.根据会话对象创建一个Task(发送请求）
        let dataTask : URLSessionTask = session.dataTask(with: request, completionHandler: { (data, response, error) in
            
            if(error == nil){
                
                //6.解析服务器返回的数据
                //说明：（此处返回的数据是JSON格式的，因此使用NSJSONSerialization进行反序列化处理）
                var dict:NSDictionary? = nil
                
                do {
                   
                    dict  = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary
                    
                } catch {

                }
                
                print("%@",dict ?? "")
            }
            
        })
        //5.执行任务
        dataTask.resume()
    }
    
    
    //发送POST请求NSURLSession
    
    func POST(){
        //1.创建会话对象
        let session: URLSession = URLSession.shared
        //2.根据会话对象创建task
        let url: URL = URL(string: "http://120.25.226.186:32812/login")!
        //3.创建可变的请求对象
        var request: URLRequest = URLRequest(url: url)
        //4.修改请求方法为POST
        request.httpMethod = "POST"
        //5.设置请求体
        request.httpBody = "username=520it&pwd=520it&type=JSON".data(using: String.Encoding.utf8, allowLossyConversion: true)
        //6.根据会话对象创建一个Task(发送请求）
       
        let dataTask: URLSessionTask = session.dataTask(with: request, completionHandler: { (data, response, error) in
            
            if(error == nil){
                //8.解析数据
                //说明：（此处返回的数据是JSON格式的，因此使用NSJSONSerialization进行反序列化处理）
                var dict:NSDictionary? = nil
                do {
                    
                  dict  = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary
                
                } catch {
                }
                print("%@",dict ?? "")
            }
        })
        
        dataTask.resume()
    }

    

    
}
