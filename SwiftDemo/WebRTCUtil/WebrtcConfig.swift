//
//  WebrtcConfig.swift
//  JimuPro
//
//  Created by Sam on 2019/10/30.
//  Copyright © 2019 UBTech. All rights reserved.
//

import Foundation


//IP地址
//10.201.126.1
//192.168.1.132
fileprivate let socketHost:String = "10.201.126.1"
//端口号
fileprivate let socketPort:UInt16 = 6869

// Set this to the machine's address which runs the signaling server
//fileprivate let defaultSignalingServerUrl = URL(string: "ws://10.10.77.241")!
fileprivate let defaultSignalingServerUrl = URL(string: "ws://192.168.81.248:8080/")!

// We use Google's public stun servers. For production apps you should deploy your own stun/turn servers.
fileprivate let defaultIceServers = ["stun:stun.l.google.com:19302"]
//获取IP端口
struct SocketConfig {
    
    var host : String = socketHost
    var port : UInt16  = socketPort
    var webRTCIceServers: [String] = defaultIceServers

    init(host: String, port: UInt16, webRTCIceServers: [String] = defaultIceServers){
        self.host = host
        self.port = port
        self.webRTCIceServers = webRTCIceServers
    }

    static let `default` = SocketConfig(host: socketHost, port: socketPort, webRTCIceServers: defaultIceServers)

}
