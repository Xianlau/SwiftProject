//
//  LayoutMethod.swift
//  SwiftDemo
//
//  Created by sam   on 2020/6/4.
//  Copyright © 2020 sam  . All rights reserved.
//

import UIKit
 
struct LayoutMethod {

    ///横屏情况下的宽度设置
    ///
    /// - Parameters:
    ///   - iPhoneWidth: iPhone6 垂直方向@2x尺寸
    ///   - iPadWidth: 分辨率比例为768*1024的iPad
    /// - Returns: 适配后的尺寸

   static  func autoLayoutWidth(iPhoneWidth: CGFloat, iPadWidth: CGFloat? = nil) -> CGFloat {
        var autoWidth: CGFloat = 0.0
        let normalWidth:CGFloat = 667.0//以iphone6为标准  375 * 667
        let actualwidth = LayoutTool.autoScreenWidth//横屏下的屏幕宽度
        //iphone的自动布局
        if UIDevice.isIphone {
            if UIDevice.isiPhoneXSeries() {//是否iPhone X系列
                autoWidth = (iPhoneWidth * ((actualwidth - 78.0) / normalWidth)).rounded(3)//精确到小数点后3位
            }else{
                 autoWidth = (iPhoneWidth * (actualwidth/normalWidth)).rounded(3)
            }
        //iPad的自动布局
        }else if UIDevice.isIpad{
            guard let ipadW = iPadWidth else {
                autoWidth = (iPhoneWidth * (actualwidth/normalWidth)).rounded(3)
                return autoWidth
            }
            autoWidth = (ipadW * (actualwidth/normalWidth)).rounded(3)
        }
        return autoWidth
    }
    
     ///横屏情况下的高度设置
     ///
     /// - Parameters:
     ///   - iPhoneH: iPhone6 垂直方向
     ///   - iPadH: 分辨率比例为768*1024的iPad
     /// - Returns: 适配后的尺寸

    static  func autoLayoutHeight(iPhoneHeight: CGFloat, iPadHeight: CGFloat? = nil) -> CGFloat {

        var autoHeight: CGFloat = 0.0
        let normalHeight:CGFloat = 375.0//以iphone6为标准  375 * 667
        let actualHeight = LayoutTool.autoScreenHeight //横屏下的屏幕高度
         //iphone的自动布局
         if UIDevice.isIphone {
            autoHeight = (iPhoneHeight * (actualHeight/normalHeight)).rounded(3)
        //iPad的自动布局
         }else if UIDevice.isIpad{
            
            guard let ipadH = iPadHeight else {
                autoHeight = (iPhoneHeight * (actualHeight/normalHeight)).rounded(3)
                return autoHeight
            }
            autoHeight = (ipadH * (actualHeight/normalHeight)).rounded(3)
         }
         return autoHeight
     }


}

public extension CGFloat {
    ///精确到小数点后几位
    func rounded(_ decimalPlaces: Int) -> CGFloat {
        let divisor = pow(10.0, CGFloat.maximum(0, CGFloat(decimalPlaces)))
        return CGFloat((CGFloat(self) * divisor).rounded() / divisor)
    }
}
