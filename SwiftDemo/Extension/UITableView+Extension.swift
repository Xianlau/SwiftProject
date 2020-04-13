//
//  UITableView+Extension.swift
//  Jimu
//
//  Created by Glen on 2018/3/6.
//  Copyright © 2018年 ubt. All rights reserved.
//

import Foundation

// 给 UITableView 进行方法扩展，增加使用类型进行注册和复用的方法
extension UITableView {
    
    ///注册一个代码cell
    func register(_ cellClass: UITableViewCell.Type) {
        let identifier = String(describing: cellClass)
        register(cellClass, forCellReuseIdentifier: identifier)
    }
    //    func dequeueReusableCell(with cellClass: UITableViewCell.Type, for indexPath: IndexPath) -> UITableViewCell {
    //        let identifier = String(describing: cellClass)
    //        return dequeueReusableCell(withIdentifier: identifier, for: indexPath)
    //    }
    ///解决复用返回代码 cell 需要进行强制类型转换, 用泛型来解决这个问题.
    func dequeueReusableCell<T: UITableViewCell>(with cellClass: T.Type, for indexPath: IndexPath) -> T {
        let identifier = String(describing: cellClass)
        return dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! T
    }
    
    ///注册一个xib cell
    func registerNib<T: UITableViewCell>(_ cellClass: T) {
        let identifier = cellClass.className
        register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
    }
    func dequeueReusableXibCell<T: UITableViewCell>(with cellClass: T, for indexPath: IndexPath) -> T {
        let identifier = cellClass.className
        return dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! T
    }
    
}

extension UITableView {
    
    ///设置headerView
    func setTableHeaderView(headerView: UIView, height: Float) {
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        self.tableHeaderView = headerView
        headerView.snp.makeConstraints { (make) in
            make.top.width.centerX.equalTo(self)
            make.height.equalTo(height)
        }
    }
    
    ///更新headerView的frame
    func shouldUpdateHeaderViewFrame() -> Bool {
        guard let headerView = self.tableHeaderView else {
            return false
        }
        
        let oldSize = headerView.bounds.size
        // Update the size
        headerView.layoutIfNeeded()
        let newSize = headerView.bounds.size
        return oldSize != newSize
    }
}


extension UICollectionView {
    ///注册一个代码cell
    func register(_ cellClass: UICollectionViewCell.Type) {
        let identifier = String(describing: cellClass)
        register(cellClass, forCellWithReuseIdentifier: identifier)
    }
    ///解决复用返回代码 cell 需要进行强制类型转换, 用泛型来解决这个问题.
    func dequeueReusableCell<T: UICollectionViewCell>(with cellClass: T.Type, for indexPath: IndexPath) -> T {
        let identifier = String(describing: cellClass)
        return dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! T
    }
}

