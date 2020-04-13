//
//  WebRTCViewController.swift
//  SwiftDemo
//
//  Created by sam   on 2019/8/28.
//  Copyright © 2019 sam  . All rights reserved.
//

import UIKit
import WebRTC
import CocoaAsyncSocket

struct SocketModel {
    static let targetHost = "10.10.27.124"
    static let targetPort : UInt16 = 5556
}

class WebRTCViewController: UIViewController {

    let factory = RTCPeerConnectionFactory()
    
    var localStream : RTCMediaStream?
    
    var connection : RTCPeerConnection?
    var tcpSocket : GCDAsyncSocket?
    var accepttcpSocket : GCDAsyncSocket?
    
    var remoteVideoTrack : RTCVideoTrack?
    
    var videoCapturer: RTCVideoCapturer?
    var localVideoTrack: RTCVideoTrack?
    
    var isoffering = false
    
    var tempStr = ""
    
    var setLocal = false
    var setRemote = false
    var sentICE = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        //如果你需要安全一点，用到SSL验证，那就加上这句话。还没有仔细研究，先加上
        //RTCPeerConnectionFactory.initialize()
        
        //初始化socket
        tcpSocket = GCDAsyncSocket(delegate: self, delegateQueue: DispatchQueue.main)
        
        //创建本地视频流，并显示到页面上
        createLocalStream()
        
        let ICEServers : [RTCIceServer] = [RTCIceServer]()
        //        ICEServers.append(defaultSTUNServer(url: "stun:stun.l.google.com:19302"))
        //        ICEServers.append(defaultSTUNServer(url: "turn:numb.viagenie.ca"))
        
        let cfg = RTCConfiguration.init()
        cfg.iceServers = ICEServers
        
        let constraints = RTCMediaConstraints(mandatoryConstraints: nil, optionalConstraints: nil)
        connection = factory.peerConnection(with: cfg, constraints: constraints, delegate: self)
        //加入本地视频流
        connection?.add(localStream!)
        
    }

    func createLocalStream() {
        
        let renderer: RTCMTLVideoView = RTCMTLVideoView(frame: CGRect(x: 100, y: 100, width: 200, height: 200))
        localStream = factory.mediaStream(withStreamId: "ARDAMS")
        
        
        //Audios
        let audioSonstrains = RTCMediaConstraints(mandatoryConstraints: nil, optionalConstraints:  nil)
        let audioSource = factory.audioSource(with: audioSonstrains)
        let audioTrack = factory.audioTrack(with: audioSource, trackId: "ARDAMSa0")
        localStream?.addAudioTrack(audioTrack)
        
        //video
        let videoSource = factory.videoSource()
        self.videoCapturer = RTCCameraVideoCapturer(delegate: videoSource)
        let videoTrack = factory.videoTrack(with: videoSource, trackId: "")
        self.localVideoTrack = videoTrack
        localStream?.addVideoTrack(videoTrack)
        
        self.view.addSubview(renderer)

        let frontCamera = (RTCCameraVideoCapturer.captureDevices().first{$0.position == .front})
        let format = (RTCCameraVideoCapturer.supportedFormats(for: frontCamera!).sorted(by: { (f1, f2) -> Bool in
          return true
        }).last)
        
        
        guard let capture = (self.videoCapturer as? RTCCameraVideoCapturer) else {
            return
        }
        capture.startCapture(with: frontCamera!, format: format!, fps: 60)
    
        localStream?.videoTracks.first?.add(renderer)
    }

}


extension WebRTCViewController: GCDAsyncSocketDelegate {
    
    // 断开连接
    func socketDidDisconnect(_ sock: GCDAsyncSocket, withError err: Error?) {

    }
    // 连接成功
    func socket(_ sock: GCDAsyncSocket, didConnectToHost host: String, port: UInt16) {
        
        
        let address = "服务器IP：" + "\(host)"

    }
    // 接收到消息
    func socket(_ sock: GCDAsyncSocket, didRead data: Data, withTag tag: Int) {
        
        let text = String(data: data, encoding: .utf8)
        
    }
    
}

extension WebRTCViewController: RTCPeerConnectionDelegate {
    func peerConnection(_ peerConnection: RTCPeerConnection, didChange stateChanged: RTCSignalingState) {
   
    }
    
    func peerConnection(_ peerConnection: RTCPeerConnection, didAdd stream: RTCMediaStream) {
       
    }
    
    func peerConnection(_ peerConnection: RTCPeerConnection, didRemove stream: RTCMediaStream) {
       
    }
    
    func peerConnectionShouldNegotiate(_ peerConnection: RTCPeerConnection) {
       
    }
    
    func peerConnection(_ peerConnection: RTCPeerConnection, didChange newState: RTCIceConnectionState) {
        
    }
    
    func peerConnection(_ peerConnection: RTCPeerConnection, didChange newState: RTCIceGatheringState) {
       
    }
    
    func peerConnection(_ peerConnection: RTCPeerConnection, didGenerate candidate: RTCIceCandidate) {
       
    }
    
    func peerConnection(_ peerConnection: RTCPeerConnection, didRemove candidates: [RTCIceCandidate]) {
        
    }
    
    func peerConnection(_ peerConnection: RTCPeerConnection, didOpen dataChannel: RTCDataChannel) {
        
    }
    
    
    
    
    
    
    
}
