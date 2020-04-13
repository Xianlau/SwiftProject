//
//  UITextView+Extension.swift
//  MusicWorld
//
//  Created by David Jia on 5/9/2017.
//  Copyright © 2017 David Jia. All rights reserved.
//

import UIKit

/// init method
extension UITextView {
    
    /// quick way to create a text view
    convenience init (textColor: UIColor, textFontSize: CGFloat, keyboardType: UIKeyboardType = .default) {
        
        self.init()
        
        self.textColor = textColor
        self.font = UIFont.systemFont(ofSize: textFontSize)
        self.keyboardType = keyboardType
    }
}

extension UITextView {
    
    /// 设置属性
    ///
    /// - Parameters:
    ///   - textColor: 字体颜色
    ///   - textFontSize: 字体大小
    ///   - keyboardType: 键盘类型
    func set(textColor: UIColor, textFontSize: CGFloat, keyboardType: UIKeyboardType = .default) {
        
        self.textColor = textColor
        self.font = UIFont.systemFont(ofSize: textFontSize)
        self.keyboardType = keyboardType
    }
}
