//
//  SocketProtocal.swift
//  WebRTC-Demo
//
//  Created by Sam on 2019/9/6.
//  Copyright © 2019 UBTech. All rights reserved.
//

import Foundation
import HandyJSON
import SwiftyJSON
import CocoaAsyncSocket

// MARK:- 头尾和加密
enum HeadTail: UInt8 {
    case head = 0xab
    case tail = 0xee
    case encrypt_method = 0
}

// MARK:- 数据类型
enum SigType: String{
    
    case login = "login_req"//登录
    case login_resp = "login_resp"//接收到登录返回信息
    case newpeer_notify = "newpeer_notify"//新设备加入了
    case peer_disconnected_notify  =  "peer_disconnected_notify"//客户端断开连接
    case heartbeat_req = "heartbeat_req"//发送心跳
    case heartbeat_resq = "heartbeat_resp"//接收心跳
    case sdp = "sdp" 
    case  icecandidate = "icecandidate"
    case error = ""
}

// MARK:- 传输的数据结构
struct SocketInfo:HandyJSON {

    var type:String?//类型
    var source:Int = 0 //用户id
    var destination:Int = 1 //目标id
    var status:Int = 0//是否成功
    var detail_info: Any?//具体数据 json

    init(type: SigType, source:Int, destination:Int, params:Any) {

        self.type = type.rawValue
        self.source = source
        self.destination = destination
        self.detail_info = params
    }
    
    init() {
        
    }
}

struct PeerList {
    var peerId:Int = 0
    var device:String = "aabb"
}

extension SocketClient {

    // MARK:- 对发送的命令打包
    func packData(info: SocketInfo) -> Data {
        var data:Data = Data()
        var length:UInt16 = 3//自身两个字节不算 头部1个加密1个尾部1个
        //加上头部长度
        var head:UInt8 = HeadTail.head.rawValue
        //加上加密方式,暂时填0
        var encrypt_method:UInt8 = 0
        //尾部
        var tail:UInt8 = HeadTail.tail.rawValue

        //数据
        if let json = info.toJSON() {
            
            //print(json)
            let infoData:Data = try! JSONSerialization.data(withJSONObject: json, options: [])
            //数据长度 //加上尾部一个字节
            length = length + UInt16(infoData.count)
            let b1 = length & 0xff
            let b2 = (length >> 8) & 0xff
            let bytes:[UInt8] = [UInt8(b2), UInt8(b1)]
            //print(bytes)
            //加上两个字节的长度
            data.append(bytes, count: MemoryLayout.size(ofValue: length))
            //加上头部数据
            data.append(&head, count: MemoryLayout.size(ofValue: head))
            //加密数据
            data.append(&encrypt_method, count: MemoryLayout.size(ofValue: encrypt_method))
            //加上数据
            data.append(infoData)
            //加上尾部
            data.append(&tail, count: MemoryLayout.size(ofValue: tail))
            //print(data)
        }
        //print(length)
        return data
    }
    
    // MARK:- 解析收到的命令包    长度2位+头1位+加密1位+包体+结尾1位
     func unpackData(_ data: Data) -> SocketInfo? {
    
        
        self.dataBuffer.append(data)
        
        //如果>5个字节代表有数据  长度2头1加密1尾1
        if self.dataBuffer.count > 5, self.dataBuffer[2] == HeadTail.head.rawValue {
            //获取长度 长度包括头.加密.数据.尾
            var length:UInt16 = 0
            let lengthData1:UInt8 = self.dataBuffer[0]
            let lengthData2:UInt8 = self.dataBuffer[1]
            length = (UInt16(lengthData1) << 8) + UInt16(lengthData2)
            //print(length)
            
            //如果长度length大于3个字节代表有数据 length两位
            //取到一个包的结尾一位
            let tailIndex:Int = Int(length + 2 - 1)//加上length两位是总的deda的count
            if length > 3, self.dataBuffer.count > length - 3, self.dataBuffer[tailIndex] == HeadTail.tail.rawValue {
                
                let infoData = self.dataBuffer[4...(tailIndex - 1)]
                let jsonStr = String(data: infoData, encoding: .utf8)
                //print(jsonStr ?? "aaaaaaaaaaaaaa")
                //jsonStr转模型
                let socketInfo:SocketInfo? = SocketInfo.deserialize(from: jsonStr)
//                if let socketPage = socketInfo {
//                    print( "收到一个socket解析数据: \(socketPage)")
//                }
                //移除已经拆过的包
                self.dataBuffer.removeSubrange(0...tailIndex)
                
                //去处理命令
                self.handleReceiveData(socketInfo)
                
                return socketInfo
                
            }else{
                //self.dataBuffer.removeAll()
                //debugPrint("socket接收数据有误")
            }
            
        }else{
                debugPrint("图传 socket接收数据有误")
             self.dataBuffer.removeAll()
        }
        return nil
    }
    
    // MARK:- 发送登录命令
    func login(){
        
        let dic = ["device_type" : "ios"]
        let info:SocketInfo = SocketInfo.init(type: .login, source: self.peer_id, destination: self.remote_peer_id, params: dic)
        let data = self.packData(info: info)
        //print(data)
        self.sendMessage(data)
    }
    
    // MARK:-处理接收的信息
    func handleReceiveData(_ socketInfo:SocketInfo?){
        
        guard let info = socketInfo, let type = info.type else {
          return
        }
        let sigType:SigType = SigType(rawValue: type) ?? .error
        let json =  JSON(info.detail_info as Any)
        
        switch sigType {

        case .login_resp://登录返回的信息peer_id

            self.peer_id = json["peer_id"].int ?? 0
            self.remote_peer_id = json["peer_list"][0]["peer_id"].int ?? 1
            debugPrint("****************************************接收到登录数据****************************************")
            
            self.delegate?.signalClientdidLogin(self)

        case .newpeer_notify://新的设备加入
            debugPrint("接收到新设备数据")
            //print(info.detail_info!)

        case .heartbeat_resq://接收心跳
            debugPrint("接收到socket心跳")
            self.receiveHeartBeatDuation = 0//接收到心跳复位

        case .sdp://收到sdp
            
            print("****************************************接收到sdp***********************")
            print(json)
            let sdpDic = json["sdp"].dictionary
            guard let sdpObjc = SDPSocket.deserialize(from: sdpDic) else {
                return
            }
            //print(sdpObjc.toJSON() as Any)
            self.delegate?.signalClient(self, didReceiveRemoteSdp: sdpObjc.rtcSessionDescription)

        case .icecandidate:

            print("****************************************接收到ice****************************************")
            print(json)
            let dic = json["icecandidate"].dictionary
            guard let iceObjc = IceCandidate_Socket.deserialize(from: dic) else {
                return
            }
            //print(iceObjc.toJSON() as Any)
            self.delegate?.signalClient(self, didReceiveCandidate: iceObjc.rtcIceCandidate)

        default:
            //print(info.toJSON() as Any)
            //print(info.detail_info ?? "")
            debugPrint("socket接收到其他未知数据")
        }
        
    }

    // MARK:- 心跳
    func sendHeartBeat(){
        
        let dic = ["" : ""]
        let info:SocketInfo = SocketInfo.init(type: .heartbeat_req, source: self.peer_id, destination: self.remote_peer_id, params: dic)
        let data = self.packData(info: info)
        //print(data)
        self.sendMessage(data)
    }

    // MARK:- 开启发送心跳定时器
    func startHeartbeatTimer(){
        self.sendHeartbeatTimer = Timer.scheduledTimer(timeInterval: TimeInterval(3), target: self, selector: #selector(startHeartbeat), userInfo: nil, repeats: true)
    }
    
    @objc func startHeartbeat() {
        
        self.sendHeartBeat()
    }
    
    // MARK:- 开启接收心跳定时器
    func startReceiveHeartbeatTimer(){
        self.receiveHeartbearTimer = Timer.scheduledTimer(timeInterval: TimeInterval(3), target: self, selector: #selector(startHeartbeat), userInfo: nil, repeats: true)
    }
    
    @objc func receiveHeartbeat() {
        
        self.receiveHeartBeatDuation += 1
        if self.receiveHeartBeatDuation >= 60  {//心跳超时
            disconnectSocket()
        }
    }
    
    // MARK:- 断开socket
    func disconnectSocket() {
        self.socket.disconnect()
        
        //停止发送接收心跳包
        self.sendHeartbeatTimer?.invalidate()
        self.sendHeartbeatTimer = nil
        self.receiveHeartbearTimer?.invalidate()
        self.receiveHeartbearTimer = nil
    }
    
}
