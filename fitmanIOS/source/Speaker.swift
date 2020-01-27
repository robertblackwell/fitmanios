//
//  Controller.swift
//  fitman
//
//  Created by Robert BLACKWELL on 1/8/20.
//  Copyright © 2020 Robert Blackwell. All rights reserved.
//
//import Cocoa
import SwiftUI
import Foundation
import AVFoundation


class Speaker: NSObject, AVSpeechSynthesizerDelegate {
    var avSpeechSynthesizer: AVSpeechSynthesizer?
    override init() {
        self.avSpeechSynthesizer = AVSpeechSynthesizer()
        super.init()
        #if LIST_VOICES
        let speechVoices = AVSpeechSynthesisVoice.speechVoices()
        speechVoices.forEach { (voice) in
          print("**********************************")
          print("Voice identifier: \(voice.identifier)")
          print("Voice language: \(voice.language)")
          print("Voice name: \(voice.name)")
          print("Voice quality: \(voice.quality.rawValue)") // Compact: 1 ; Enhanced: 2
        }
        #endif
    }
    func announce(_ exercise: Exercise) {
        self.avSpeechSynthesizer = AVSpeechSynthesizer()
        self.avSpeechSynthesizer!.delegate = self
        self.say(exercise.label + " for \(exercise.duration) seconds")
    }
    func say(_ text: String) {
        self.avSpeechSynthesizer = AVSpeechSynthesizer()
        self.avSpeechSynthesizer!.delegate = self
        let utterance = AVSpeechUtterance(string: text)
        utterance.rate = 0.5
        #if os(OSX)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
        utterance.voice = AVSpeechSynthesisVoice(identifier: "com.apple.speech.synthesis.voice.daniel.premium")
        #else
        utterance.voice = AVSpeechSynthesisVoice(language: "en-AU")
        utterance.voice = AVSpeechSynthesisVoice(identifier: "com.apple.ttsbundle.Karen-compact")
        #endif
        DispatchQueue.global(qos: .background).async {
            self.avSpeechSynthesizer!.speak(utterance)
        }
    }
    func playSound(sound: String) {
        DispatchQueue.global(qos: .background).async {
            #if USE_NSSOUND
                NSSound(named: sound)!.play()
            #else
                SoundPlayer.shared().play(name: "\(sound).aiff")
            #endif
        }
    }
    func playTinkSound() {
        playSound(sound: "Tink")
    }
    func playPurrSound() {
        playSound(sound: "Purr")
    }
    func playPopSound() {
        playSound(sound: "Pop")
    }
    func stopSpeech() {
        if (self.avSpeechSynthesizer != nil) {
            self.avSpeechSynthesizer!.stopSpeaking(at: AVSpeechBoundary.immediate)
        }
    }
    func pauseSpeech() {
        if (self.avSpeechSynthesizer != nil) {
            self.avSpeechSynthesizer!.pauseSpeaking(at: AVSpeechBoundary.immediate)
        }
    }
    func resumeSpeech() {
        if (self.avSpeechSynthesizer != nil) {
            self.avSpeechSynthesizer!.continueSpeaking()
        }
    }
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        Trace.writeln("didFinish")
    }
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
    }
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didPause utterance: AVSpeechUtterance) { }
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didContinue utterance: AVSpeechUtterance) {}
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) { }
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance) { }
}
