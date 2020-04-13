//
//  UILabel+Extension.swift
//  MusicWorld
//
//  Created by David Jia on 15/8/2017.
//  Copyright © 2017 David Jia. All rights reserved.
//

import UIKit

// MARK: - init method
extension UILabel {
    
    /// quick way to create a label
    convenience init (title: String, fontSize: CGFloat, color: UIColor, alignment: NSTextAlignment = .left, isBold: Bool = false) {
        
        self.init()
        
        self.text = title
        self.font = isBold ? UIFont.boldSystemFont(ofSize: fontSize) : UIFont.systemFont(ofSize: fontSize)
        self.textColor = color
        self.textAlignment = alignment
    }
}

// MARK: - instance method
extension UILabel {

    func set(title: String, fontSize: CGFloat, color: UIColor, alignment: NSTextAlignment = .left, isBold: Bool = false ) {

        self.text = title
        self.font = isBold ? UIFont.boldSystemFont(ofSize: fontSize) : UIFont.systemFont(ofSize: fontSize)
        self.textColor = color
        self.textAlignment = alignment
    }
}
