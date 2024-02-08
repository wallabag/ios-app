import AVFoundation
import Foundation
import MediaPlayer
import Observation
import SwiftUI

#if os(iOS)
    @Observable
    final class PlayerPublisher {
        static var shared = PlayerPublisher()
        private var speecher = AVSpeechSynthesizer()
        private var utterance: AVSpeechUtterance?

        var podcast: Podcast?
        var showPlayer: Bool = false
        private(set) var isPlaying = false {
            willSet {
                if newValue {
                    play()
                } else {
                    pause()
                }
            }
        }

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
            isPlaying = false
            showPlayer = true
            podcast = Podcast(id: entry.id, title: entry.title ?? "Title", content: entry.content?.withoutHTML ?? "", picture: entry.previewPicture)
            utterance = AVSpeechUtterance(string: podcast!.content)
            MPNowPlayingInfoCenter.default().nowPlayingInfo = [
                MPMediaItemPropertyTitle: entry.title,
                MPMediaItemPropertyArtist: "Wallabag",
            ]
            try? AVAudioSession.sharedInstance().setActive(true)
            try? AVAudioSession.sharedInstance().setCategory(.playback)
        }

        func togglePlaying() {
            isPlaying = !isPlaying
        }

        func play() {
            guard let utterance else { return }
            if !speecher.isSpeaking {
                speecher.speak(utterance)
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
            isPlaying = false
            speecher.stopSpeaking(at: .immediate)
        }

        func togglePlayer() {
            showPlayer.toggle()
        }
    }
#endif
