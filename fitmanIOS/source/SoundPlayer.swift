//
//  SoundPLayer.swift
//  nssound-replacement
//
//  Created by Robert BLACKWELL on 1/24/20.
//  Copyright © 2020 Robert Blackwell. All rights reserved.
//

import Foundation
import AVFoundation

fileprivate let instance = SoundPlayer()

class SoundPlayer {
    public static func shared() -> SoundPlayer {
        return instance
    }
    // accumulated soundID so that the URL lookup result is cached.
    public var soundCache = [String: SystemSoundID]()

    public func play(name: String) {
        if let soundID = self.soundCache[name] {
               AudioServicesPlaySystemSound(soundID)
        } else {
            if let soundPath = Bundle.main.path(forResource: "Sounds/\(name)", ofType: nil) {
                let soundURL: NSURL = NSURL(fileURLWithPath: soundPath)
                var soundID  : SystemSoundID = 0
                let osStatus : OSStatus = AudioServicesCreateSystemSoundID(soundURL, &soundID)
                if osStatus == kAudioServicesNoError {
                    AudioServicesPlayAlertSound(soundID);
                    self.soundCache[name] = (soundID)
                } else {
                    print("did not work")
                  // This happens in exceptional cases
                  // Handle it with no sound or retry
               }
           }
        }
    }
    // SystemSoundID are 'C' pointers and must be deallocated after use.
    // They are accumulated iin the LookupTable and deallocated when instance
    // is garbage collected
    deinit {
        for soundID in self.soundCache.values {
           AudioServicesDisposeSystemSoundID(soundID)
        }
    }
}
