//
//  WallabagState.swift
//  wallabag
//
//  Created by maxime marinel on 10/09/2018.
//

import Foundation
import WallabagCommon

class WallabagState {
    enum State {
        case missingConfiguration
        case configured
        case connected
        case fetching
    }
    let setting = WallabagSetting()
    static let shared = WallabagState()
    var currentState: State {
        didSet {
            Log("Update state")
        }
    }
    private init() {
        currentState = setting.get(for: .wallabagIsConfigured) ? .configured : .missingConfiguration
    }
}
