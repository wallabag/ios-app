//
//  PodcastViewController.swift
//  wallabag
//
//  Created by maxime marinel on 06/08/2018.
//

import UIKit
import AVFoundation
import WallabagCommon
import StoreKit

class PodcastViewController: UIViewController {
    @IBOutlet var playButton: UIButton!
    @IBOutlet var slider: UIPodcastSlider!
    @IBOutlet var thumb: UIImageView!

    private var currentUtteranceIndex: Int = 0 {
        didSet {
            slider.value = Float(currentUtteranceIndex)
        }
    }

    /*enum viewState {
        case show
        case hidden
    }
    private var state: viewState = .show
    private let analytics = AnalyticsManager()
    private var speecher: AVSpeechSynthesizer = AVSpeechSynthesizer()
    private var utterances: [AVSpeechUtterance] = []

    weak var entry: Entry!

    var isPaid: Bool = false

    @IBAction func playPressed(_ sender: UIButton) {
        Log("Play pressed")
        if !speecher.isSpeaking {
            utterances.forEach { speecher.speak($0) }
            //analytics.send(.synthesis(state: true))
        } else {
            if speecher.isPaused {
                speecher.continueSpeaking()
            } else {
                speecher.pauseSpeaking(at: .word)
            }
            // analytics.send(.synthesis(state: false))
        }
    }

    override func viewDidLoad() {
        speecher.delegate = self
        utterances = getUtterances()
        prepareView()

        isPaid = WallabagStore.shared.hasReceiptData

        Log(isPaid)
    }

    private func prepareView() {
        thumb.display(entry: entry, withShadow: true)
        slider.prepare()
        view.layer.cornerRadius = 20
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.shadowPath = UIBezierPath(roundedRect: view.bounds, cornerRadius: view.layer.cornerRadius).cgPath
        view.layer.shadowColor = UIColor.black.cgColor
        self.view.layer.shadowOpacity = 0.5
        self.view.layer.shadowRadius = 10
    }

    @IBAction func next(_ sender: UIButton) {
        Log("next pressed")
        var nextUtterances = utterances
        nextUtterances.removeSubrange(0...currentUtteranceIndex)
        speecher.stopSpeaking(at: .immediate)
        nextUtterances.forEach { speecher.speak($0) }
    }

    private func getUtterances() -> [AVSpeechUtterance] {
        guard let content = entry.content else {return []}

        if isPaid {
            for paragraph in content.speakable {
                let utterance = AVSpeechUtterance(string: paragraph.withoutHTML)
                utterance.postUtteranceDelay = 0.4
                utterance.rate = Setting.getSpeechRate()
                utterance.voice = Setting.getSpeechVoice()
                utterances.append(utterance)
            }
            //slider.displayTick(tick: utterances.count)
        } else {
            let utterance = AVSpeechUtterance(string: content.withoutHTML)
            utterance.rate = Setting.getSpeechRate()
            utterance.voice = Setting.getSpeechVoice()
            utterances.append(utterance)
        }

        slider.maximumValue = Float(utterances.count)
        slider.minimumValue = 0.0
        slider.value = 0

        return utterances
    }

    func toggle() {
        if state == .hidden {
            state = .show
            animShow()
        } else {
            state = .hidden
            animHide()
        }
    }

    private func animShow(){
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseIn],
                       animations: {
                        self.view.center.y -= self.view.bounds.height
                        self.view.layoutIfNeeded()
        }, completion: nil)
        self.view.isHidden = false
    }

    private func animHide(){
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveLinear],
                       animations: {
                        self.view.center.y += self.view.bounds.height
                        self.view.layoutIfNeeded()

        },  completion: {(_ completed: Bool) -> Void in
            self.view.isHidden = true
        })
    }*/
}

extension PodcastViewController: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance) {
        //currentUtteranceIndutteranceances.index(of: utterance) ?? 0
    }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        playButton.setImage(UIImage(named: "pause"), for: .normal)
    }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didContinue utterance: AVSpeechUtterance) {
        playButton.setImage(UIImage(named: "pause"), for: .normal)
    }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didPause utterance: AVSpeechUtterance) {
        playButton.setImage(UIImage(named: "play"), for: .normal)
    }
}
