//
//  PodcastViewController.swift
//  wallabag
//
//  Created by maxime marinel on 06/08/2018.
//

import AVFoundation
import UIKit
import WallabagCommon

class PodcastViewController: UIViewController {
    @IBOutlet var playButton: UIButton!
    @IBOutlet var slider: UIPodcastSlider!
    @IBOutlet var thumb: UIImageView!

    private var currentUtteranceIndex: Int = 0 {
        didSet {
            slider.value = Float(currentUtteranceIndex)
        }
    }

    var analytics: AnalyticsManagerProtocol!
    var setting: WallabagSetting!
    private var speecher: AVSpeechSynthesizer = AVSpeechSynthesizer()
    private var utterances: [AVSpeechUtterance] = []

    weak var entry: Entry!

    @IBAction func playPressed(_ button: UIButton) {
        defer {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                button.isEnabled = true
            }
        }

        if button.isEnabled {
            button.isEnabled = false
            Log("Play pressed")
            if !speecher.isSpeaking {
                utterances.forEach { speecher.speak($0) }
                analytics.send(.synthesis(state: true))
            } else {
                if speecher.isPaused {
                    speecher.continueSpeaking()
                } else {
                    speecher.pauseSpeaking(at: .word)
                }
            }
        }
    }

    override func viewDidLoad() {
        speecher.delegate = self
        utterances = getUtterances()
        prepareView()
    }

    private func prepareView() {
        thumb.display(entry: entry, withShadow: true)
        slider.prepare()
        view.layer.cornerRadius = 20
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.shadowPath = UIBezierPath(roundedRect: view.bounds, cornerRadius: view.layer.cornerRadius).cgPath
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.5
        view.layer.shadowRadius = 10
    }

    @IBAction func next(_: UIButton) {
        Log("next pressed")
        var nextUtterances = utterances
        nextUtterances.removeSubrange(0 ... currentUtteranceIndex)
        speecher.stopSpeaking(at: .immediate)
        nextUtterances.forEach { speecher.speak($0) }
    }

    private func getUtterances() -> [AVSpeechUtterance] {
        guard let content = entry?.content else { return [] }
        let utterance = AVSpeechUtterance(string: content.withoutHTML)
        utterance.rate = setting.get(for: .speechRate)
        utterance.voice = setting.getSpeechVoice()
        utterances.append(utterance)

        slider.displayTick(tick: utterances.count)
        slider.maximumValue = Float(utterances.count)
        slider.minimumValue = 0.0
        slider.value = 0

        return utterances
    }
}

extension PodcastViewController: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_: AVSpeechSynthesizer, willSpeakRangeOfSpeechString _: NSRange, utterance _: AVSpeechUtterance) {
        // currentUtteranceIndutteranceances.index(of: utterance) ?? 0
    }

    func speechSynthesizer(_: AVSpeechSynthesizer, didStart _: AVSpeechUtterance) {
        playButton.setImage(UIImage(named: "pause"), for: .normal)
    }

    func speechSynthesizer(_: AVSpeechSynthesizer, didContinue _: AVSpeechUtterance) {
        playButton.setImage(UIImage(named: "pause"), for: .normal)
    }

    func speechSynthesizer(_: AVSpeechSynthesizer, didPause _: AVSpeechUtterance) {
        playButton.setImage(UIImage(named: "play"), for: .normal)
    }
}
