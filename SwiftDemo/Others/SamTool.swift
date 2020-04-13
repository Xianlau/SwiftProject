//
//  SamTool.swift
//  SwiftDemo
//
//  Created by sam   on 2019/4/24.
//  Copyright © 2019 sam  . All rights reserved.
//

import UIKit

//
//extension UIImage{
//
//
//    /// 压缩图片数据-不压尺寸
//    ///
//    /// - Parameters:
//    ///   - maxLength: 最大长度
//    /// - Returns:
//    func compressImageOnlength(maxLength: Int) -> Data? {
//
//        guard let vData = self.jpegData(compressionQuality: 1) else { return nil }
//        print("压缩前kb: \( Double((vData.count)/1024))")
//        if vData.count < maxLength {
//            return vData
//        }
//        var compress:CGFloat = 0.9
//        guard var data = self.jpegData(compressionQuality: compress) else { return nil }
//        while data.count > maxLength && compress > 0.01 {
//            print("压缩比: \(compress)")
//            compress -= 0.02
//            data = self.jpegData(compressionQuality: compress)!
//        }
//        print("压缩后kb: \(Double((data.count)/1024))")
//        return data
//    }
//
//}
//
//extension NSObject {
//
//    var Sam_ClassName: String {
//
//        //let project_cls_name: String = String(describing: self) //返回的是一个对象信息
//        let project_cls_name: String = NSStringFromClass(type(of: self))//返回的是一个对象名称字符串
//        let range = (project_cls_name as NSString).range(of: ".")
//        let cls_name = (project_cls_name as NSString).substring(from: range.location + 1) as String
//        return cls_name
//    }
//
//
//}
//
////会崩溃
//extension UITableViewCell{
//
//    class func cellWithTableView<T: UITableViewCell>(tableView : UITableView, cellCls:T.Type) -> T {
//        let cellID = NSStringFromClass(T.self)
//        //let cellid = T().Sam_ClassName
//        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellID)
//        if cell == nil {
//            cell =  T.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: cellID)
//        }
//            return cell as! T
//    }
//
//}
//
//// 给 UITableView 进行方法扩展，增加使用类型进行注册和复用的方法
//extension UITableView {
//
//    //注册一个代码cell
//    func register(_ cellClass: UITableViewCell.Type) {
//        let identifier = String(describing: cellClass)
//        register(cellClass, forCellReuseIdentifier: identifier)
//    }
////    func dequeueReusableCell(with cellClass: UITableViewCell.Type, for indexPath: IndexPath) -> UITableViewCell {
////        let identifier = String(describing: cellClass)
////        return dequeueReusableCell(withIdentifier: identifier, for: indexPath)
////    }
//    //解决复用返回代码 cell 需要进行强制类型转换, 用泛型来解决这个问题.
//    func dequeueReusableCell<T: UITableViewCell>(with cellClass: T.Type, for indexPath: IndexPath) -> T {
//        let identifier = String(describing: cellClass)
//        return dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! T
//    }
//    
//    //注册一个xib cell
//    func registerNib<T: UITableViewCell>(_ cellClass: T) {
//        let identifier = cellClass.Sam_ClassName
//        register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
//    }
//    func dequeueReusableXibCell<T: UITableViewCell>(with cellClass: T, for indexPath: IndexPath) -> T {
//        let identifier = cellClass.Sam_ClassName
//        return dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! T
//    }
//
//}


//tableView.register(CustomCell.self)
//override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//    let cell = tableView.dequeueReusableCell(with: CustomCell.self, for: indexPath)
//    cell.index = indexPath.row
//    return cell
//}

