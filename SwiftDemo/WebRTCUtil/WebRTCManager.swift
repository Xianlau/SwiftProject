
//
//  WebtrtcManager.swift
//  JimuPro
//
//  Created by Sam on 2019/10/30.
//  Copyright © 2019 UBTech. All rights reserved.
//

import Foundation
import AVFoundation
import WebRTC

// MARK:- 图传连接状态
public enum RtcConnectedState {
    
    case sucessed //连接成功
    case falure   //连接失败
    case connecting //正在连接
}


protocol WebRTCManagerDelegate: class {

    //socket是否连接上
    func webRTCManager(_ manager: WebRTCManager, socketConnectState isSucessed: Bool)
    
    //webrtc连接状态
    func webRTCManager(_ manager: WebRTCManager, didChangeConnectionState state: RTCIceConnectionState)
}

class WebRTCManager {
    
    static let shareInstance:WebRTCManager  = WebRTCManager()
    
    //private let signalClient: SignalingClient
    var signalClient: SocketClient?
    var webRTCClient: WebRTCClient?

    ///初始化的时候请传入config
    var sockitConfig: SocketConfig =  SocketConfig.default
    
    //代理
    weak var delegate: WebRTCManagerDelegate?
    
    var remoteCandidate: Int = 0
    ///rtc连接成功回调
    var feedbackConnectedBlock: ((_ webClient: WebRTCClient)->())?

    // MARK:- 断开socket连接
    public func disconnect(){
        
        self.signalClient?.disconnectSocket()
        
        self.webRTCClient?.disconnect()
        self.signalClient?.delegate = nil
        self.webRTCClient?.delegate = nil
        self.signalClient = nil
        self.webRTCClient = nil
        remoteCandidate = 0
    }
    // MARK:- 开始连接socket
    public func connect(){

        //打印RTC日记
        //RTCSetMinDebugLogLevel(.verbose)
        //let log = RTCFileLogger.init()
        //log.start()
        
        //创建socket和rtc对象
        signalClient = SocketClient.init(hostStr: sockitConfig.host, port: sockitConfig.port)
        webRTCClient = WebRTCClient(iceServers: sockitConfig.webRTCIceServers)
        webRTCClient?.delegate = self
        signalClient?.delegate = self

        self.signalClient?.connect()
    }
    
}

extension WebRTCManager: SocketClientDelegate {
    
    //socket登录成功
    func signalClientdidLogin(_ signalClient: SocketClient) {
        debugPrint("********socket登录成功************************")
    }
    
    // MARK:- socket连接成功
    func signalClientDidConnect(_ signalClient: SocketClient) {

        self.delegate?.webRTCManager(self, socketConnectState: true)
    }

    // MARK:- socket连接失败
    func signalClientDidDisconnect(_ signalClient: SocketClient) {
        
        self.delegate?.webRTCManager(self, socketConnectState: false)
    }
    
    // MARK:- 收到对方sdp
    func signalClient(_ signalClient: SocketClient, didReceiveRemoteSdp sdp: RTCSessionDescription) {
        debugPrint("************收到对方sdp****************************")
        
        //设置远方sdp
        self.webRTCClient?.set(remoteSdp: sdp) { (error) in
            
            self.webRTCClient?.answer { (localSdp) in
                
                self.signalClient?.send(sdp: localSdp)
            }
            
            debugPrint(error.debugDescription)
        }
        
    }
    // MARK:- 收到对方ice
    func signalClient(_ signalClient: SocketClient, didReceiveCandidate candidate: RTCIceCandidate) {
         debugPrint("************收到对方ice****************************")
        
        self.remoteCandidate += 1
        //设置远方ice
        self.webRTCClient?.set(remoteCandidate: candidate)
    }
}

extension WebRTCManager: WebRTCClientDelegate {
    
    // MARK:- 收到本地ice
    func webRTCClient(_ client: WebRTCClient, didDiscoverLocalCandidate candidate: RTCIceCandidate) {
        debugPrint("********************************发现本地 ice candidate **********")
        
        self.signalClient?.send(candidate: candidate)
    }
    // MARK:- rtc连接状态
    func webRTCClient(_ client: WebRTCClient, didChangeConnectionState state: RTCIceConnectionState) {
        
        self.delegate?.webRTCManager(self, didChangeConnectionState: state)
        
        switch state {
        case .connected, .completed:
            
            debugPrint("*********RTC连接状态成功*****************************************")
            if let block = feedbackConnectedBlock {
                block(client)
            }
            
        case .disconnected:
            debugPrint("*********RTC失去连接*****************************************")
            
        case .failed, .closed:
            
            debugPrint("*********RTC连接失败*****************************************")
        case .new, .checking, .count: break
            
        @unknown default: break
            
        }

    }
    // MARK:- 收到rtc 数据通道数据
    func webRTCClient(_ client: WebRTCClient, didReceiveData data: Data) {
//        DispatchQueue.main.async {
//            let message = String(data: data, encoding: .utf8) ?? "(Binary: \(data.count) bytes)"
//            let alert = UIAlertController(title: "Message from WebRTC", message: message, preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
//            self.present(alert, animated: true, completion: nil)
//        }
    }
}


