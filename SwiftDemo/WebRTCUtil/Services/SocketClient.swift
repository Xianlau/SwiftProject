//
//  SocketClient.swift
//  WebRTC-Demo
//
//  Created by Sam on 2019/9/6.
//  Copyright © 2019 UBTech. All rights reserved.
//

import Foundation
import CocoaAsyncSocket
import WebRTC
import HandyJSON

// MARK: - socket状态代理
protocol SocketClientDelegate: class {
    
    func signalClientDidConnect(_ signalClient: SocketClient)
    func signalClientDidDisconnect(_ signalClient: SocketClient)
    func signalClient(_ signalClient: SocketClient, didReceiveRemoteSdp sdp: RTCSessionDescription)
    func signalClient(_ signalClient: SocketClient, didReceiveCandidate candidate: RTCIceCandidate)
    
    func signalClientdidLogin(_ signalClient: SocketClient)
}

final class SocketClient: NSObject {
    
    //socket
    let socket: GCDAsyncSocket =  GCDAsyncSocket.init()
    
    private var host: String? //服务端IP
    private var port: UInt16? //端口
    weak var delegate: SocketClientDelegate?//代理
    
    var receiveHeartBeatDuation = 0 //心跳计时计数
    let heartBeatOverTime = 10 //心跳超时
    var sendHeartbeatTimer:Timer? //发送心跳timer
    var receiveHeartbearTimer:Timer? //接收心跳timer

    //接收数据缓存  因为使用分包策略
    var dataBuffer:Data = Data.init()
    
    //登录获取的peer_id
    var peer_id = 0
    //登录获取的远程设备peer_id
    var remote_peer_id = 0

    // MARK:- 初始化
    init(hostStr: String , port: UInt16) {
        super.init()
        
        self.socket.delegate = self
        self.socket.delegateQueue = DispatchQueue.main
        self.host = hostStr
        self.port = port
    }

    // MARK:- 开始连接
    func connect() {
        
        do {
            try  self.socket.connect(toHost: self.host ?? "", onPort: self.port ?? 6868, withTimeout: -1)
            
        }catch {
            print(error)
        }
    }
    
    // MARK:- 发送消息
    func sendMessage(_ data: Data){
        self.socket.write(data, withTimeout: -1, tag: 0)
    }

    // MARK:- 发送sdp offer/answer
    func send(sdp rtcSdp: RTCSessionDescription) {
        
        //转成我们的sdp
        let type = rtcSdp.type
        var typeStr = ""
        switch type {
        case .answer:
            typeStr = "answer"
        case .offer:
            typeStr = "offer"
        default:
            print("sdpType错误")
        }
        let newSDP:SDPSocket = SDPSocket.init(sdp: rtcSdp.sdp, type: typeStr)
        let jsonInfo = newSDP.toJSON()
        let dic = ["sdp" : jsonInfo]
        let info:SocketInfo = SocketInfo.init(type: .sdp, source: self.peer_id, destination: self.remote_peer_id, params: dic as Dictionary<String, Any>)
        let data = self.packData(info: info)
        //print(data)
        self.sendMessage(data)
        debugPrint("************************发送SDP*******************")
    }

    // MARK:- 发送iceCandidate
    func send(candidate rtcIceCandidate: RTCIceCandidate) {
        
        let iceCandidateMessage = IceCandidate_Socket(from: rtcIceCandidate)
        let jsonInfo = iceCandidateMessage.toJSON()
        let dic = ["icecandidate" : jsonInfo]
        let info:SocketInfo = SocketInfo.init(type: .icecandidate, source: self.peer_id, destination: self.remote_peer_id, params: dic as Dictionary<String, Any>)
        let data = self.packData(info: info)
        //print(data)
        self.sendMessage(data)
         debugPrint("*********************************发送ICE********************************")
    }
}

extension SocketClient: GCDAsyncSocketDelegate {
    
    // MARK:- socket连接成功
    func socket(_ sock: GCDAsyncSocket, didConnectToHost host: String, port: UInt16) {
        
        debugPrint("socket连接成功")
        self.delegate?.signalClientDidConnect(self)
        
        //登录获取身份id peer_id
        login()
        //发送心跳
        startHeartbeatTimer()
        //开启接收心跳计时
        startReceiveHeartbeatTimer()
        
        //继续接收数据
        socket.readData(withTimeout: -1, tag: 0)
    }
    
    // MARK:- 接收数据  socket接收到一个数据包
    func socket(_ sock: GCDAsyncSocket, didRead data: Data, withTag tag: Int) {

        let _:SocketInfo? = self.unpackData(data)
        //继续接收数据
        socket.readData(withTimeout: -1, tag: 0)
    }
    
    // MARK:- 断开连接
    func socketDidDisconnect(_ sock: GCDAsyncSocket, withError err: Error?) {
        
        debugPrint("socket意外断开连接")
        self.disconnectSocket()
        self.delegate?.signalClientDidDisconnect(self)
    }

}
