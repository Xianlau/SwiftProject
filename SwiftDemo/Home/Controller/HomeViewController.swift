//
//  HomeViewController.swift
//  SwiftDemo
//
//  Created by sam   on 2020/4/7.
//  Copyright © 2020 sam  . All rights reserved.
//

import UIKit

protocol HomeRouterHandle {
    func gotoHomeSubmodule(_ submodule: HomeSubmodule, params: Dictionary<String, Any>?)
}

class HomeViewController: BaseViewController {

    private var router: HomeRouter?
    
    lazy var tableview: UITableView = {
        let tableview: UITableView = UITableView(frame:self.view.bounds, style: .plain)
        tableview.backgroundColor = .black
        tableview.delegate = self
        tableview.dataSource = self
        tableview.rowHeight = 50
        return tableview
    }()
    
    let itemARR: [String] = ["alamofire + SwiftyJSON + HandyJson 的使用", "DSBridge H5和原生的交互", "反射_基本用法" ,"反射_模型转字典", "WCDB数据库"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        router = HomeRouter.init(self)
        
        self.navigationItem.title = "home"

        self.view.addSubview(tableview)
        //注册cell
        tableview.register(UITableViewCell.self)
    }
}

extension HomeViewController: UITableViewDelegate,UITableViewDataSource  {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.itemARR.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(with: UITableViewCell.self, for: indexPath) as UITableViewCell
        cell.selectionStyle = .none
        cell.textLabel?.text = self.itemARR[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        tableView.deselectRow(at: indexPath, animated: false)
        let rawValue =  HomeSubmodule(rawValue: indexPath.row)
        
        switch rawValue {
        case .photoList:
            router?.gotoHomeSubmodule(.photoList, params: nil)
            
        case .dSBridge:
            router?.gotoHomeSubmodule(.dSBridge, params: nil)
            
        case .Model_To_Dictionary:
            router?.gotoHomeSubmodule(.Model_To_Dictionary, params: nil)
            
        case .mirrorVC:
            router?.gotoHomeSubmodule(.mirrorVC, params: nil)
            
        case .WCDB_VC:
            router?.gotoHomeSubmodule(.WCDB_VC, params: nil)
            
        default:
            break
        }
    }
    
}
