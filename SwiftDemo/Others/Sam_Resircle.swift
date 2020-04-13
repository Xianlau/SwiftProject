//
//  Sam_Resircle.swift
//  SwiftDemo
//
//  Created by sam   on 2019/4/30.
//  Copyright © 2019 sam  . All rights reserved.
//


import UIKit


/*
 *循环引用
 *
 */
class Sam_Resircle: NSObject {

    weak var student : SamTest?
    
    let name:String = ""
    let jValue:String? = nil
    
    lazy var samJson : () -> String = {
        
        [unowned self] in //使用无主引用来解决强引用循环
        
        if let text = self.jValue {
            return "\(self.name):\(text)"
        }else{
            return "text is nil"
        }
    }
    
    
    
}
