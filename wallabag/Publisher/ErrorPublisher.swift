//
//  ErrorPublisher.swift
//  wallabag
//
//  Created by Marinel Maxime on 15/02/2020.
//

import Combine
import Foundation

class ErrorPublisher: ObservableObject {
    private var resetAfter: DispatchTime

    init(_ resetAfter: DispatchTime = .now() + 10) {
        self.resetAfter = resetAfter
    }

    @Published var lastError: WallabagError? {
        willSet {
            if nil != newValue {
                DispatchQueue.main.asyncAfter(deadline: resetAfter) { [weak self] in
                    self?.lastError = nil
                }
            }
        }
    }
}
