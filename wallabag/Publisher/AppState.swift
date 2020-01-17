//
//  AppState.swift
//  wallabag
//
//  Created by Marinel Maxime on 09/10/2019.
//

import Combine
import Foundation

class AppState: ObservableObject {
    @Published var registred: Bool = false {
        didSet {
            WallabagUserDefaults.registred = registred
        }
    }
    
    @Published var hasError: Bool = false
    @Published var lastError: String? {
        willSet {
            hasError = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                self.hasError = false
                self.lastError = nil
            }
        }
    }

    @Published var showPlayer: Bool = false

    @Injector var session: WallabagSession

    init() {
        registred = WallabagUserDefaults.registred
        if registred {
            initSession()
        }
    }

    private func initSession() {
        session.requestSession()
    }
    
    func logout() {
        registred = false
    }
}
