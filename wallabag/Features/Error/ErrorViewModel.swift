//
//  ErrorViewModel.swift
//  wallabag
//
//  Created by Marinel Maxime on 15/02/2020.
//

import Combine
import Foundation

class ErrorViewModel: ObservableObject {
    private var resetAfter: Double

    init(_ resetAfter: Double = 10) {
        self.resetAfter = resetAfter
    }

    @Published private(set) var lastError: WallabagError?

    func setLast(_ error: WallabagError) {
        lastError = error
        DispatchQueue.main.asyncAfter(deadline: .now() + resetAfter) { [weak self] in
            self?.lastError = nil
        }
    }
}
