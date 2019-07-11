//
//  ArticlePlayer.swift
//  wallabag
//
//  Created by Marinel Maxime on 10/07/2019.
//

import Foundation
import AVFoundation
import WallabagCommon
import MediaPlayer

class ArticlePlayer {
    
    private var speecher: AVSpeechSynthesizer = AVSpeechSynthesizer()
    
    var analytics: AnalyticsManagerProtocol!
    var setting: SettingProtocol!
    var isPlaying: Bool {
        get {
            return speecher.isSpeaking
        }
    }
    var isLoaded: Bool {
        get {
            return utterance != nil
        }
    }
    private var utterance: AVSpeechUtterance?
    
    func load(_ entry: Entry) {
        speecher.stopSpeaking(at: .immediate)
        guard let content = entry.content else { return }
        utterance = AVSpeechUtterance(string: content.withoutHTML)
        utterance?.rate = setting.get(for: .speechRate)
        utterance?.voice = setting.getSpeechVoice()
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = [
            MPMediaItemPropertyTitle: entry.title,
            MPMediaItemPropertyArtist: "Wallabag"
        ]
        play()
    }
    
    func play() {
        guard let utterance = utterance else {
            return
        }
            if !speecher.isSpeaking {
                speecher.speak(utterance)
                analytics.send(.synthesis(state: true))
            } else {
                if speecher.isPaused {
                    speecher.continueSpeaking()
                } else {
                    speecher.pauseSpeaking(at: .word)
                }
            }
    }
    
    func pause() {
        speecher.pauseSpeaking(at: .word)
    }
    
    func stop() {
        speecher.stopSpeaking(at: .immediate)
    }
}
