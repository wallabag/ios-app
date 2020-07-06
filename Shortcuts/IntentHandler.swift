//
//  IntentHandler.swift
//  Shortcuts
//
//  Created by Marinel Maxime on 01/07/2020.
//

import Intents

class IntentHandler: INExtension {
    override func handler(for intent: INIntent) -> Any {
        switch intent {
        case is AddEntryIntent:
            return AddEntryIntentHandler()
        default:
            fatalError()
        }
    }
}
