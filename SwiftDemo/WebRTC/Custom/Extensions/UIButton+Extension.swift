//
//  UIButton+Extension.swift
//  MusicWorld
//
//  Created by David Jia on 15/8/2017.
//  Copyright © 2017 David Jia. All rights reserved.
//

import UIKit

// MARK: - init method
extension UIButton {
    
    /// quick way to create a button with image and background image
    convenience init (normalImage: UIImage? = nil, selectedImage: UIImage? = nil, backgroundImage: UIImage? = nil) {
        
        self.init()
        
        setImage(normalImage, for: .normal)
        setImage(selectedImage, for: .selected)
        setBackgroundImage(backgroundImage, for: .normal)
    }
    
    /// create a button with title/fontSize/TitleColor/bgColor
    convenience init (title: String, fontSize: CGFloat, titleColor: UIColor, selTitleColor: UIColor? = nil, bgColor: UIColor = UIColor.clear, isBold: Bool = false)  {
        
        self.init()
        
        setTitle(title, for: .normal)
        titleLabel?.font = isBold ? UIFont.boldSystemFont(ofSize: fontSize) : UIFont.systemFont(ofSize: fontSize)
        setTitleColor(titleColor, for: .normal)
        setTitleColor(selTitleColor == nil ? titleColor : selTitleColor, for: .selected)
        backgroundColor = bgColor
    }
}

// MARK: - instance method
extension UIButton {

    func setup(title: String, selTitle: String? = nil, fontSize: CGFloat, isBold: Bool = false, titleColor: UIColor, bgColor: UIColor = UIColor.clear, titleOffset: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)) {
        
        setTitle(title, for: .normal)
        setTitle(selTitle == nil ? title : selTitle, for: .selected)
        titleLabel?.font = isBold ? UIFont.boldSystemFont(ofSize: fontSize) : UIFont.systemFont(ofSize: fontSize)
        setTitleColor(titleColor, for: .normal)
        backgroundColor = bgColor
        titleEdgeInsets = titleOffset
    }
}
