//
//  VoiceChoiceTableViewController.swift
//  wallabag
//
//  Created by maxime marinel on 24/07/2017.
//  Copyright © 2017 maxime marinel. All rights reserved.
//

import UIKit
import AVFoundation

final class VoiceChoiceTableViewController: UITableViewController {

    let voices: [AVSpeechSynthesisVoice] = AVSpeechSynthesisVoice.speechVoices()
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return voices.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        let voice: AVSpeechSynthesisVoice = voices[indexPath.row]

        cell.textLabel?.text = "\(voice.name) (\(voice.language))"

        if voice.language == Setting.getSpeechVoice()?.language {
            cell.accessoryType = .checkmark
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        for row in 0 ... tableView.numberOfRows(inSection: indexPath.section) {
            tableView.cellForRow(at: IndexPath(row: row, section: indexPath.section))?.accessoryType = .none
        }
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        tableView.deselectRow(at: indexPath, animated: true)

        Setting.setSpeechVoice(language: voices[indexPath.row].language)
        _ = navigationController?.popViewController(animated: true)
    }
}
