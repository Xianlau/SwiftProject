//
//  Sample.swift
//  SwiftDemo
//
//  Created by sam   on 2020/4/17.
//  Copyright © 2020 sam  . All rights reserved.
//

import UIKit
import WCDBSwift

class Sample: NSObject,TableCodable {
    
    var id: Int = 0
    var ssid: String?
    var password: String?

    enum CodingKeys: String, CodingTableKey {
        typealias Root = Sample
        static let objectRelationalMapping = TableBinding(CodingKeys.self)

        case id
        case ssid
        case password
        
        //Column constraints for primary key, unique, not null, default value and so on. It is optional.
        static var columnConstraintBindings: [CodingKeys: ColumnConstraintBinding]? {
            return [
                .id: ColumnConstraintBinding(isPrimary: true, isAutoIncrement: true)//自增主键
            ]
        }

    }
    
    /// 用于定义是否使用自增的方式插入
    var isAutoIncrement: Bool = true
    
    /// 用于获取自增插入后的主键值
    var lastInsertedRowID: Int64 = 0
}
