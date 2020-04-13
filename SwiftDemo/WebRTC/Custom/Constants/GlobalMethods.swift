//
//  GlobalMethods.swift
//  MusicWorld
//
//  Created by David Jia on 16/8/2017.
//  Copyright © 2017 David Jia. All rights reserved.
//

import Foundation
import UIKit

/// get gray color
func MW_RGBCOLOR(_ value: CGFloat, alpha: CGFloat = 1.0) ->UIColor{
    
    return UIColor(red: value / 255.0, green: value / 255.0, blue: value / 255.0, alpha: alpha)
}
// MARK: - Font

/// setup font
func MW_FONT(_ fontSize: CGFloat) -> UIFont {

    return UIFont.systemFont(ofSize: fontSize)
}
/// setup bold font
func MW_BOLD_FONT(_ fontSize: CGFloat) -> UIFont {
    
    return UIFont.boldSystemFont(ofSize: fontSize)
}

/// current screen width
///
/// - Returns: screen width
func MW_SCREEN_WIDTH() -> CGFloat {
    
    return UIScreen.main.bounds.width
}
