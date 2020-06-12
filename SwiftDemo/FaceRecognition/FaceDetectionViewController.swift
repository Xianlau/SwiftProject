//
//  FaceDetectionViewController.swift
//  SwiftDemo
//
//  Created by sam   on 2020/6/11.
//  Copyright © 2020 sam  . All rights reserved.
//

import UIKit
import SnapKit

class FaceDetectionViewController: BaseViewController {
    
    lazy var imageView: UIImageView = {
        let imageview = UIImageView.init()
        imageview.backgroundColor = .lightGray
        imageview.contentMode = .scaleAspectFit
        return imageview
    }()
    lazy var faceCountLabel: UILabel = {
        let label = UILabel.init()
        label.backgroundColor = .green
        label.text = "识别到0个人脸"
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white

        setUI()
        
    }
    
    private func setUI() {
        
        let chosePicBtn = UIButton(type: .custom)
        chosePicBtn.setTitle("选择照片", for: .normal)
        chosePicBtn.backgroundColor = .orange
        chosePicBtn.addTarget(self, action: #selector(choosePic), for: .touchUpInside)
        
        let detectBtn = UIButton(type: .custom)
        detectBtn.setTitle("开始检测", for: .normal)
        detectBtn.backgroundColor = .orange
        detectBtn.addTarget(self, action: #selector(startDetect), for: .touchUpInside)
        
        view.addSubviews([imageView, chosePicBtn, detectBtn, faceCountLabel])
        
        imageView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(autoWidth(30))
            make.top.equalToSuperview().offset(autoWidth(30) + LayoutTool.topSafeInset + 44)
            make.right.equalToSuperview().offset(autoWidth(-30))
            make.height.equalTo(autoHeihgt(300))
        }
        
        faceCountLabel.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom).offset(5)
            make.left.right.equalTo(imageView)
            make.height.equalTo(autoHeihgt(20))
        }
        
        chosePicBtn.snp.makeConstraints { (make) in
            make.top.equalTo(faceCountLabel.snp.bottom).offset(30)
            make.left.right.equalTo(imageView)
            make.height.equalTo(autoHeihgt(45))
        }
        
        detectBtn.snp.makeConstraints { (make) in
            make.top.equalTo(chosePicBtn.snp.bottom).offset(20)
            make.left.right.equalTo(imageView)
            make.height.equalTo(autoHeihgt(45))
        }
        

        
        
    }
    
    // MARK: - 开始检测人脸
    @objc private func startDetect() {
        
        FaceRecognition.startRecognize(imageView: imageView) { (count) in
            print("**********************************************************检测到\(count)个人脸")
            self.faceCountLabel.text = "检测到\(count)个人脸"
        }
        
    }
    
    // MARK: - 选择相册图片
    @objc private func choosePic() {
        
        //1. 判断是否允许该操作
        if !UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            print("用户没开访问相册权限, 请到设置里面开启")
            return
        }
        
        //创建照片选择器
        let imagePC = UIImagePickerController()
        //设置数据源
        imagePC.sourceType = .photoLibrary

        imagePC.delegate = self
        present(imagePC, animated: true, completion: nil)
    }

}

//MARK: 实现相册代理
extension FaceDetectionViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //获取选中的图片
        guard let selectorImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        imageView.image = selectorImage
        picker.dismiss(animated: true, completion: nil)
    }
    
    //选取完成后调用
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
