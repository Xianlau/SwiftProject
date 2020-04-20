//
//  SessionDescription.swift
//  WebRTC-Demo
//
//  Created by Sam on 20/02/2019.
//  Copyright © 2019 UBTech. All rights reserved.
//

import Foundation
import WebRTC
import HandyJSON

/// This enum is a swift wrapper over `RTCSdpType` for easy encode and decode
enum SdpType: String, Codable {
    case offer, prAnswer, answer
    
    var rtcSdpType: RTCSdpType {
        switch self {
        case .offer:    return .offer
        case .answer:   return .answer
        case .prAnswer: return .prAnswer
        }
    }
}

/// This struct is a swift wrapper over `RTCSessionDescription` for easy encode and decode
struct SessionDescription: Codable,HandyJSON  {
    
    var sdp: String
    var type: SdpType
    
    init(from rtcSessionDescription: RTCSessionDescription) {
        self.sdp = rtcSessionDescription.sdp
        
        switch rtcSessionDescription.type {
        case .offer:    self.type = .offer
        case .prAnswer: self.type = .prAnswer
        case .answer:   self.type = .answer
        @unknown default:
            fatalError("Unknown RTCSessionDescription type: \(rtcSessionDescription.type.rawValue)")
        }
    }
    
    var rtcSessionDescription: RTCSessionDescription {
        return RTCSessionDescription(type: self.type.rtcSdpType, sdp: self.sdp)
    }
    
    init() {

        sdp = ""
        type = .answer
    }
}

struct SDPSocket: HandyJSON {
    
    let sdp: String
    let type: String
    var rtcSessionDescription: RTCSessionDescription {
        let typeRTC:RTCSdpType
        switch type {
        case "answer":
            typeRTC = .answer
        case "offer":
            typeRTC = .offer
        default:
            typeRTC = .prAnswer
        }
        return RTCSessionDescription(type: typeRTC, sdp: self.sdp)
    }
    
    init() {
        sdp = ""
        type = ""
    }
    
    init( sdp:String, type:String) {
        
        self.sdp = sdp
        self.type = type
    }
}
