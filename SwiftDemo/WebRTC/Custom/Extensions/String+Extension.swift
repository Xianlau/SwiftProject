//
//  String+Extension.swift
//  MusicWorld
//
//  Created by David Jia on 24/8/2017.
//  Copyright © 2017 David Jia. All rights reserved.
//

import UIKit

// MARK - attribute string
extension String {
    
    func attributedString(rangeArray: Array<Dictionary<String, Any>>, fontArray: Array<UIFont>, colorArray: Array<UIColor>, lineSpacing: CGFloat = 0) -> NSMutableAttributedString {
    
        // 如果range数组为空，直接返回自己
        if rangeArray.count == 0 {
            return NSMutableAttributedString(string: self)
        }
        
        // 如果数组元素个数不一致，直接把返回自己
        if (rangeArray.count != fontArray.count) || (rangeArray.count != colorArray.count) {
            return NSMutableAttributedString(string: self)
        }
        
        // 带属性字符串
        let attrContent = NSMutableAttributedString(string: self)
        
        for index in 0..<rangeArray.count {
            
            // 获取range
            let dict = rangeArray[index];
            let location:String = dict[MW_RANGE_LOCATION] as! String;
            let length:String = dict[MW_RANGE_LENGTH] as! String;
            
            // range
            let range = NSMakeRange(Int(location)!, Int(length)!);
            
            // 字体大小
            attrContent.addAttribute(NSAttributedString.Key.font, value: fontArray[index], range: range)
            
            // 字体颜色
            attrContent.addAttribute(NSAttributedString.Key.foregroundColor, value: colorArray[index], range: range)
        }
        
        // 内容行间距
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing;
        
        attrContent.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, self.count))
        
        return attrContent;
    }
    
    /// 获取字符串长度
    ///
    /// - Returns: 长度
    func length() -> Int {
        return self.count
    }
}

