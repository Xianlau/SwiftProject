//
//  DBmanager.swift
//  SwiftDemo
//
//  Created by sam   on 2020/4/17.
//  Copyright © 2020 sam  . All rights reserved.
//

import WCDBSwift


struct WcdbDataPath {
    
   static let basePath =  NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! + "/DB/wcdb.db"
}
enum DBTableName : String {

    case sampleTable = "Sample"
}

class DBmanager: NSObject {

    static let share = DBmanager.init()
    var db: Database?
    
    override init() {
        super.init()
        db = createDB()
        createTable()
    }
    
    private func createDB() -> Database {
       return Database(withPath: WcdbDataPath.basePath)
    }
    
    /// 数据库与表的初始化
    private func createTable() {
        do {
         //1. 创建主数据库main的相关表
           try db?.run(transaction: {
            createTable(table: DBTableName.sampleTable, modelType: Sample.self)
            })
         
        } catch let error {
            print("初始化数据库及ORM对应关系建立失败\(error.localizedDescription)")
        }
    }

    ///创建表
    private func createTable<T: TableDecodable>(table: DBTableName, modelType: T.Type) {
        do {
            try db?.create(table: table.rawValue, of: modelType)
        }catch let error {
            debugPrint(error.localizedDescription)
        }
    }
    
    ///插入数据
    public func inser<T: TableEncodable>(objects:[T], intoTable table: DBTableName){
        do {
            try db?.insert(objects: objects, intoTable: table.rawValue)
        }catch let error {
            debugPrint(error.localizedDescription)
        }
    }

    ///修改
    public func update<T: TableEncodable>(fromTable table: DBTableName, on propertys:[PropertyConvertible], itemModel object:T,where condition: Condition? = nil){
        do {
            try db?.update(table: table.rawValue, on: propertys, with: object, where: condition)
        } catch let error {
            debugPrint(" update obj error \(error.localizedDescription)")
        }
    }

    ///删除
    public func deleteFromDb(fromTable table: DBTableName, where condition: Condition? = nil){
        do {
            try db?.delete(fromTable: table.rawValue, where:condition)
        } catch let error {
            debugPrint("delete error \(error.localizedDescription)")
        }
    }

    ///查询
    public func qurey<T: TableDecodable>(fromTable table: DBTableName, where condition: Condition? = nil, orderBy orderList:[OrderBy]? = nil) -> [T]? {
        do {
            let allObjects: [T] = try (db?.getObjects(fromTable: table.rawValue, where:condition, orderBy:orderList))!
            debugPrint("\(allObjects)");
            return allObjects
        } catch let error {
            debugPrint("no data find \(error.localizedDescription)")
        }
        return nil
    }
    
    ///删除数据表
    func dropTable(table: DBTableName) -> Void {
        do {
            try db?.drop(table: table.rawValue)
        } catch let error {
            debugPrint("drop table error \(error)")
        }
    }
    
    /// 删除所有与该数据库相关的文件
    func removeDbFile() -> Void {
        do {
            try db?.close(onClosed: {
                try db?.removeFiles()
            })
        } catch let error {
            debugPrint("not close db \(error)")
        }
        
    }
    
    

}
