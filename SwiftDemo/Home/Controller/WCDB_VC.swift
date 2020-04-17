//
//  WCDB_VC.swift
//  SwiftDemo
//
//  Created by sam   on 2020/4/17.
//  Copyright © 2020 sam  . All rights reserved.
//

import UIKit
import WCDBSwift


class WCDB_VC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        let a = Sample.init()
        a.password = "a1a1a11a"
        a.ssid = "aaa"
        
        let b = Sample.init()
        b.password = "b1b1b1b1b"
        b.ssid = "bbbb"
        
        let c = Sample.init()
        c.password = "c1c1c1"
        c.ssid = "cccc"
        
        
        //插入
        let arr = [a, b, c]
        DBmanager.share.inser(objects: arr, intoTable: DBTableName.sampleTable)
        
        
        //修改
        let d = Sample.init()
        d.ssid = "1d1d1d"
        d.password = "dddddd"
        let properties = [
            Sample.Properties.ssid,
            Sample.Properties.password
        ]
        DBmanager.share.update(fromTable: DBTableName.sampleTable, on: properties, itemModel: d, where: Sample.Properties.ssid == "bbbb")
        
        //删除
        DBmanager.share.deleteFromDb(fromTable: DBTableName.sampleTable, where: Sample.Properties.ssid == "aaa")
        
        //查找
        if let qureyARR:[Sample] =  DBmanager.share.qurey(fromTable: DBTableName.sampleTable, where: Sample.Properties.ssid == "aaa", orderBy: nil) {
            print(qureyARR)
        }
        
    }

}
