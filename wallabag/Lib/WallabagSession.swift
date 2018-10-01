//
//  WallabagState.swift
//  wallabag
//
//  Created by maxime marinel on 10/09/2018.
//

import Foundation
import WallabagCommon
import WallabagKit

extension Notification.Name {
    static let wallabagStateChanged = Notification.Name("wallabag.state.changed")
}

class WallabagSession {
    enum State {
        case missingConfiguration
        case error
        case configured
        case connected
        case fetching
    }
    private let setting = WallabagSetting()
    private var kit: WallabagKit?
    private var wallabagSync: WallabagSyncing?
    static let shared = WallabagSession()
    var currentState: State {
        didSet {
            Log("Update state with \(currentState)")
            NotificationCenter.default.post(name: .wallabagStateChanged, object: nil)
        }
    }
    private init() {
        currentState = setting.get(for: .wallabagIsConfigured) ? .configured : .missingConfiguration
    }

    func startSession() {
        kit = WallabagKit(
            host: setting.get(for: .host),
            clientID: setting.get(for: .clientId),
            clientSecret: setting.get(for: .clientSecret)
        )
        guard let kit = self.kit, let password = setting.getPassword() else {return}
        kit.requestAuth(
            username: setting.get(for: .username),
            password: password) { [weak self] auth in
                switch auth {
                case .success:
                   self?.currentState = .connected
                case .error(let error):
                    Log(error)
                    self?.currentState = .error
                case  .invalidParameter, .unexpectedError:
                    self?.currentState = .error
                }
        }
        wallabagSync = WallabagSyncing(kit: kit)
    }

    func sync(completion: @escaping () -> Void) {
        guard let kit = kit, currentState == .connected else { return }
        wallabagSync?.sync {
            completion()
        }
    }
}
