//
//  SamTest.swift
//  SwiftDemo
//
//  Created by sam   on 2019/4/22.
//  Copyright © 2019 sam  . All rights reserved.
//

import Foundation
import AVFoundation



class SamTest : NSObject, AVAudioPlayerDelegate{


    func samtest1(){
        var thing = "cars"
        let closure = { [thing] in
            print("i love \(thing)")
        }
        thing = "airplanes"
        closure()
    }
    
    deinit {
        print("**************************")

    }
 
}
