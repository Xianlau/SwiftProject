//
//  WebRTCVideoView.swift
//  JimuPro
//
//  Created by Sam on 2019/10/31.
//  Copyright © 2019 UBTech. All rights reserved.
//

import UIKit
import WebRTC

// MARK: - 连接状态代理
protocol WebRTCVideoViewDelegate: class {
    
    /*
     图传连接状态
     enum RtcConnectedState {
         case sucessed //连接成功
         case falure   //连接失败
         case connecting //正在连接
     }
     */
    func webRTCVideoView(_ rtcView: WebRTCVideoView, videoConnectedState state: RtcConnectedState)
    

//    /*
//     socket连接状态
//     */
//   func webRTCVideoView(_ rtcView: WebRTCVideoView, socketConnectState isSucessed: Bool)
//
//    /*
//     rtc连接状态
//     */
//  func webRTCVideoView(_ rtcView: WebRTCVideoView, rtcConnected isSucessed: Bool)
}


/*
 图传专用view
 */

class WebRTCVideoView: UIView {
    
    //代理 反馈连接各种状态
    weak public var delegate: WebRTCVideoViewDelegate?

    //视频渲染view
    private let remoteRendererView: RTCEAGLVideoView =  RTCEAGLVideoView(frame: CGRect(x: 100, y: 100, width: 300, height: 200))
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .black
        setupRTC()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        
        self.removeSubviews()
        WebRTCManager.shareInstance.disconnect()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        UIScreen.main.bounds.height
        self.remoteRendererView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(UIScreen.main.bounds.height)
            make.width.equalTo(UIScreen.main.bounds.height * 16.0 / 9.0)
        }
        //self.remoteRendererView.frame = CGRect(x: 100, y: 100, width: 300, height: 200)
        
    }
    
    private func setupRTC(){
//        JMLoadingView.show(text: "视频加载中", .modal) {
//
//        }
        //添加机器人摄像头view
        self.addSubview(self.remoteRendererView)
        self.remoteRendererView.backgroundColor = .red
        self.remoteRendererView.delegate = self

        let manager = WebRTCManager.shareInstance
        manager.delegate = self
        self.delegate?.webRTCVideoView(self, videoConnectedState: .connecting)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
           
            if  let rtcClientNew = manager.webRTCClient {

                rtcClientNew.renderRemoteVideo(to: self.remoteRendererView)
            }
        }
        manager.feedbackConnectedBlock = { rtcClient in

//            DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
//                self.addSubview(self.remoteRendererView)
//                if  let rtcClientNew = manager.webRTCClient {
//
//                    rtcClientNew.renderRemoteVideo(to: self.remoteRendererView)
//                }
//            }
        }
    }
}

extension WebRTCVideoView: WebRTCManagerDelegate {
    
    //socket
    func webRTCManager(_ manager: WebRTCManager, socketConnectState isSucessed: Bool) {
        
        //self.delegate?.webRTCVideoView(self, socketConnectState: isSucessed)
        if isSucessed {
            self.delegate?.webRTCVideoView(self, videoConnectedState: .sucessed)
        }else{
            self.delegate?.webRTCVideoView(self, videoConnectedState: .falure)
        }
        
    }
    //rtc
    func webRTCManager(_ manager: WebRTCManager, didChangeConnectionState state: RTCIceConnectionState) {

        switch state {
        case .connected, .completed:
            
             //self.delegate?.webRTCVideoView(self, rtcConnected: true)
             self.delegate?.webRTCVideoView(self, videoConnectedState: .sucessed)
            
        case .disconnected:
            
        //self.delegate?.webRTCVideoView(self, rtcConnected: false)
        self.delegate?.webRTCVideoView(self, videoConnectedState: .falure)
            
        case .failed, .closed:
            
            //self.delegate?.webRTCVideoView(self, rtcConnected: false)
            self.delegate?.webRTCVideoView(self, videoConnectedState: .falure)
            
        case .new, .checking, .count: break
            
        @unknown default: break
            
        }
    }
}

extension WebRTCVideoView: RTCVideoViewDelegate {
    
    func videoView(_ videoView: RTCVideoRenderer, didChangeVideoSize size: CGSize) {
        
        print("******************视频分辨率是\(size)*************************************************")
        
    }
    
    
}
