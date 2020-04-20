//
//  IceCandidate.swift
//  WebRTC-Demo
//
//  Created by Sam on 20/02/2019.
//  Copyright © 2019 UBTech. All rights reserved.
//

import Foundation
import WebRTC
import HandyJSON

/// This struct is a swift wrapper over `RTCIceCandidate` for easy encode and decode
struct IceCandidate: Codable, HandyJSON {

    let sdp: String
    let sdpMLineIndex: Int32
    let sdpMid: String?
    
    init(from iceCandidate: RTCIceCandidate) {
        self.sdpMLineIndex = iceCandidate.sdpMLineIndex
        self.sdpMid = iceCandidate.sdpMid
        self.sdp = iceCandidate.sdp
    }
    
    var rtcIceCandidate: RTCIceCandidate {
        return RTCIceCandidate(sdp: self.sdp, sdpMLineIndex: self.sdpMLineIndex, sdpMid: self.sdpMid)
    }
    
    init() {
        sdp = ""
        sdpMLineIndex = 1
        sdpMid = ""
    }
}

struct IceCandidate_Socket: HandyJSON {
    
    var candidate: String
    var sdpMLineIndex: Int32
    var sdpMid: String?
    
    init(from iceCandidate: RTCIceCandidate) {
        self.sdpMLineIndex = iceCandidate.sdpMLineIndex
        self.sdpMid = iceCandidate.sdpMid
        self.candidate = iceCandidate.sdp
    }
    
    var rtcIceCandidate: RTCIceCandidate {
        return RTCIceCandidate(sdp: self.candidate, sdpMLineIndex: self.sdpMLineIndex, sdpMid: self.sdpMid)
    }
    
    init() {
        candidate = ""
        sdpMLineIndex = 0
        sdpMid = "0"
    }
}
