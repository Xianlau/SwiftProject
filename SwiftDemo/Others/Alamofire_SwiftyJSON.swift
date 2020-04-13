//
//  Alamofire_SwiftyJSON.swift
//  SwiftDemo
//
//  Created by sam   on 2019/4/24.
//  Copyright © 2019 sam  . All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher

// 相当于数据模型model
class itemsModel: NSObject {
    
    var cover_image_url = ""
    var title  = ""
    var likecount = ""
    
}

class Alamofire_SwiftyJSON: UIViewController,UITableViewDelegate,UITableViewDataSource {

    lazy var gifttableview: UITableView = {
        let tableview: UITableView = UITableView(frame:self.view.bounds, style: .plain)
        tableview.backgroundColor = Color.red
        tableview.delegate = self
        tableview.dataSource = self
        tableview.rowHeight = 300
        
        return tableview
    }()
    
    // 数据源
    var dataArray = [itemsModel]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(gifttableview)
        self.AlamofireGetRequest()
        
        //注册cell
        gifttableview.register(SamTableViewCell.self)
    }

    
}

extension Alamofire_SwiftyJSON{

    func AlamofireGetRequest() {
        Alamofire.request("http://api.liwushuo.com/v2/channels/104/items?ad=2&gender=2&generation=2&limit=20&offset=0", method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
//            // 有错误就打印错误，没有就解析数据
//            if let Error = response.result.error
//            {
//                print(Error)
//            }
//            else
                if let jsonresult = response.result.value {
                // 用 SwiftyJSON 解析数据
                let JSOnDictory = JSON(jsonresult)
                let data =  JSOnDictory["data"]["items"].array
                for dataDic in data ?? []
                {
                    
                    let model =  itemsModel()
                    model.cover_image_url = dataDic["cover_image_url"].string ?? ""
                    model.title =  dataDic["title"].string ?? ""
                    
                    let  numString = String(format:"%d",dataDic["likes_count"].intValue )
                    model.likecount = numString
                    self.dataArray.append(model)
                    
                }
                
                self.gifttableview.reloadData()
                
                //print(jsonresult)
                
            }
            
        }
    }
    
    func AlamofirePostRequest() {
        let dic: [String: String] = ["key1": "value1"] // 参数
        // JSONEncoding.prettyPrinted 是提交json
        Alamofire.request("https://httpbin.org/post", method: .post, parameters: dic, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            //方式y1
            if response.error == nil {
                print("Post 请求成功：\(response.result.value ?? "")")
            }else{
                print("Post 请求失败：\(response.error ?? "" as! Error)")
            }
            
            //方式2
            switch response.result.isSuccess {
            case true:
                //把得到的JSON数据转为数组
                if let items = response.result.value as? NSArray{
                    //遍历数组得到每一个字典模型
                    for dict in items{
                        print(dict)
                    }
                }
            case false:
                print(response.result.error ?? "")
            }
            
            
            
        }
    }

    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.dataArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = UITableViewCell.cellWithTableView(tableView: tableView, cellCls: SamTableViewCell.self)
        let cell = tableView.dequeueReusableCell(with: SamTableViewCell.self, for: indexPath)
        
        let model = self.dataArray[indexPath.row]
        // 用到 Kingfisher
        cell.iconImv.kf.setImage(with: URL(string: model.cover_image_url))
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

         print(indexPath.row)
    }
    
}
