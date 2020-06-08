//
//  LayoutTool.swift
//  SwiftDemo
//
//  Created by sam   on 2020/6/4.
//  Copyright © 2020 sam  . All rights reserved.
//

import UIKit

///适配手机和平板的宽度
public func autoWidth(_ width: CGFloat) -> CGFloat {
    if  UIApplication.shared.statusBarOrientation.isLandscape {
        return LayoutMethod.autoLayoutWidth(iPhoneWidth: width)
    }else {
        return  LayoutMethod.autoLayoutHeight(iPhoneHeight: width)
    }
}
///适配手机和平板的高度
public func autoHeihgt(_ height: CGFloat) -> CGFloat {
    
    if  UIApplication.shared.statusBarOrientation.isLandscape {
        return LayoutMethod.autoLayoutHeight(iPhoneHeight: height)
    }else {
        return  LayoutMethod.autoLayoutWidth(iPhoneWidth: height)
    }
}

///系统字号
func autoFontSize(_ font: Float) -> UIFont {

    let floatSize = UIDevice.isIpad ? font * 1.5 : font
    let font : UIFont = UIFont.systemFont(ofSize: CGFloat(floatSize))
    return font
}

struct LayoutTool{
    
    ///加粗的系统字号
    static func autoBoldfontSize(_ font: Float) -> UIFont {

        let floatSize = UIDevice.isIpad ? font * 1.5 : font
        let font : UIFont = UIFont.boldSystemFont(ofSize: CGFloat(floatSize))
        return font
    }

    ///安全距离的Insets
    static var safeAreaInsets: UIEdgeInsets {
        if #available(iOS 11.0, *) {
            return UIApplication.shared.delegate?.window??.safeAreaInsets ?? .zero
        }
        return .zero
    }
    ///左边安全距离
    static let leftSafeInset = safeAreaInsets.left
    ///右边安全距离
    static let rightSafeInset = safeAreaInsets.right
    ///上边安全距离
    static let topSafeInset = safeAreaInsets.top
    ///下边安全距离
    static let bottomSafeInset = safeAreaInsets.bottom
    
    ///横屏下的屏幕宽度
    static let autoScreenWidth = max(UIScreen.main.bounds.height, UIScreen.main.bounds.width)
    
    ///横屏下的屏幕高度
    static let autoScreenHeight = min(UIScreen.main.bounds.height, UIScreen.main.bounds.width)
}










