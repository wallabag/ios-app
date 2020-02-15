//
//  ErrorPublisher.swift
//  wallabag
//
//  Created by Marinel Maxime on 15/02/2020.
//

import Combine
import Foundation

class ErrorPublisher: ObservableObject {
    @Published var lastError: WallabagError? {
        willSet {
            if nil != newValue {
                DispatchQueue.main.asyncAfter(deadline: .now() + 10) { [weak self] in
                    self?.lastError = nil
                }
            }
        }
    }
}
