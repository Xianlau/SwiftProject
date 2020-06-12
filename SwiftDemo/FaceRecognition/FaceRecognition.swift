//
//  FaceRecognition.swift
//  SwiftDemo
//
//  Created by sam   on 2020/6/12.
//  Copyright © 2020 sam  . All rights reserved.
//

import UIKit

class FaceRecognition: NSObject {

    
    static func startRecognize(imageView: UIImageView, result: @escaping (_ faceCount: Int) -> ()) {
        //删除子控件
        imageView.removeSubviews()
        
       
        guard let image = imageView.image else { return }
        guard let ciImage = CIImage(image: image) else {return}
        
        //检测质量参数
        let options = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
        //检测执行者
        let detector = CIDetector(ofType: CIDetectorTypeFace, context: CIContext(), options: options)
        //检测结果
        guard let faceResultArr = detector?.features(in: ciImage) else {return}
        //返回检测结果
        result(faceResultArr.count)
        //添加人脸框框到imageview
        addBorderView(imageView: imageView, image: image, faceResultArr: faceResultArr)
        
    }
    
    static func addBorderView(imageView: UIImageView, image: UIImage, faceResultArr: [CIFeature]) {

        // 添加识别的红框
        let borderView = UIView(frame: CGRect(x: 0, y: 0, width: imageView.frame.width, height: imageView.frame.height))
        imageView.addSubview(borderView)
        
        //遍历扫描结果
        for faceFeature in faceResultArr {
            
            print("************************************************************image 的size: \(image.size)")
            print("************************************************************imageview 的frame: \(imageView.frame)")
            print("************************************************************faceFeature 的bounds: \(faceFeature.bounds)")
            
            //拿到缩放比例 //imageView和image的尺寸比例 按照imageview.contentMode = .scaleAspectFit
             let scale = getScale(imageView: imageView, image: image)

             //人脸相对于缩放后的image的位置
             let faceOriginX: CGFloat = faceFeature.bounds.minX / scale
             let faceOriginY: CGFloat = faceFeature.bounds.minY / scale
             let faceOriginW: CGFloat =   faceFeature.bounds.width / scale
             let faceOriginH: CGFloat =   faceFeature.bounds.height / scale
             
             //缩放后的image在imageView的frame
             let imageY = (imageView.frame.height - (image.size.height / scale)) * 0.5
             let imageX = (imageView.frame.width - (image.size.width / scale)) * 0.5
             //let imageW = image.size.width / scale
             let imageH = image.size.height / scale
             
             //人脸相对新的image的frame
             let newy = imageH - faceOriginH - faceOriginY
             let newx = faceOriginX
             let neww = faceOriginW
             let newh = faceOriginH
             
             //人脸相对于imageview的frame
             let y0 = newy + imageY
             let x0 = newx + imageX
             let w0 = neww
             let h0 = newh
             

             let newrect = CGRect(x: x0, y: y0, width: w0, height: h0)
             let view = addRedrectangleView(rect: newrect)
            borderView.addSubview(view)
            
            //如果识别到眼睛
            //guard let feature = faceFeature as? CIFaceFeature else { return }
            //左眼 : feature.hasLeftEyePosition  右眼:feature.hasRightEyePosition 嘴巴: feature.hasMouthPosition
        }
    }
    
    // MARK: - 框框的绘制
    static func addRedrectangleView(rect: CGRect) -> UIView{
        let redView = UIView(frame: rect)
        redView.layer.borderColor = UIColor.red.cgColor
        redView.layer.borderWidth = 1
        return redView
    }

}


//imageView和image的尺寸比例 按照imageview.contentMode = .scaleAspectFit
extension FaceRecognition {
    
    //imageView.contentMode = .scaleAspectFit
    static func getScale(imageView: UIImageView, image: UIImage) -> CGFloat{
        let viewSize = imageView.frame.size
        let imageSize = image.size
        
        let widthScale = imageSize.width / viewSize.width
        let heightScale = imageSize.height / viewSize.height
        
        return widthScale > heightScale ? widthScale : heightScale
    }
}
