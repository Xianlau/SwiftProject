//
//  UITextField+Extension.swift
//  MusicWorld
//
//  Created by David Jia on 5/9/2017.
//  Copyright © 2017 David Jia. All rights reserved.
//

import UIKit

/// init method
extension UITextField {

    /// quick way to create a label
    convenience init (placeholder: String, placeholderColor: UIColor, placeholderFontSize: CGFloat, textColor: UIColor, textFontSize: CGFloat, keyboardType: UIKeyboardType = .default, clearButtonMode: UITextField.ViewMode = .whileEditing) {
        
        self.init()
        
        let rangeDict = [MW_RANGE_LOCATION: "0", MW_RANGE_LENGTH: "\(placeholder.length())"] as [String : Any]
        
        let attrPlaceholder = placeholder.attributedString(rangeArray: [rangeDict], fontArray: [MW_FONT(placeholderFontSize)], colorArray: [placeholderColor])
        attributedPlaceholder = attrPlaceholder
        self.textColor = textColor
        self.font = UIFont.systemFont(ofSize: textFontSize)
        self.tintColor = placeholderColor
        self.keyboardType = keyboardType
        self.clearButtonMode = clearButtonMode
    }
}
