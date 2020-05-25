//
//  Publisher.swift
//  wallabag
//
//  Created by Marinel Maxime on 27/04/2020.
//

import Combine
import Foundation

extension Publisher {
    func mapErrorToWallabagKitError() -> Publishers.MapError<Self, WallabagKitError> {
        mapError { error in
            if let error = error as? WallabagKitError {
                return error
            }
            return WallabagKitError.wrap(error: error)
        }
    }
}
