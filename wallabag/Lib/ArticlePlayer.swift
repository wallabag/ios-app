//
//  ArticlePlayer.swift
//  wallabag
//
//  Created by Marinel Maxime on 10/07/2019.
//

import AVFoundation
import Foundation
import MediaPlayer
import WallabagCommon

class ArticlePlayer {
    private var speecher: AVSpeechSynthesizer = AVSpeechSynthesizer()

    var analytics: AnalyticsManagerProtocol!
    var setting: SettingProtocol!
    var isPlaying: Bool {
        return speecher.isSpeaking
    }

    var isLoaded: Bool {
        return utterance != nil
    }

    private var utterance: AVSpeechUtterance?

    init() {
        MPRemoteCommandCenter.shared().previousTrackCommand.isEnabled = false
        MPRemoteCommandCenter.shared().nextTrackCommand.isEnabled = false
        MPRemoteCommandCenter.shared().playCommand.addTarget { _ in
            self.play()
            return .success
        }
        MPRemoteCommandCenter.shared().pauseCommand.addTarget { _ in
            self.pause()
            return .success
        }
    }

    func load(_ entry: Entry) {
        speecher.stopSpeaking(at: .immediate)
        guard let content = entry.content else { return }
        utterance = AVSpeechUtterance(string: content.withoutHTML)
        utterance?.rate = setting.get(for: .speechRate)
        utterance?.voice = setting.getSpeechVoice()
        MPNowPlayingInfoCenter.default().nowPlayingInfo = [
            MPMediaItemPropertyTitle: entry.title,
            MPMediaItemPropertyArtist: "Wallabag",
        ]
        try? AVAudioSession.sharedInstance().setActive(true)
        try? AVAudioSession.sharedInstance().setCategory(.playback)
        play()
    }

    func play() {
        guard let utterance = utterance else { return }
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
