import AVFoundation
import Combine
import Foundation
import MediaPlayer

final class PlayerPublisher: ObservableObject {
    static var shared = PlayerPublisher()

    @Published private(set) var isPlaying = false {
        willSet {
            if newValue {
                play()
            } else {
                pause()
            }
        }
    }

    @Published var podcast: Podcast?

    private var speecher = AVSpeechSynthesizer()
    private var utterance: AVSpeechUtterance?

    func load(_ entry: Entry) {
        isPlaying = false
        podcast = Podcast(id: entry.id, title: entry.title ?? "Title", content: entry.content?.withoutHTML ?? "", picture: entry.previewPicture!)
        utterance = AVSpeechUtterance(string: podcast!.content)
    }

    func togglePlaying() {
        isPlaying = !isPlaying
    }

    func play() {
        guard let utterance = utterance else { return }
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
        speecher.stopSpeaking(at: .word)
    }
}
