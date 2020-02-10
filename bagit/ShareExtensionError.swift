//
//  ShareExtensionError.swift
//  bagit
//
//  Created by Marinel Maxime on 10/02/2020.
//

import Foundation

enum ShareExtensionError: Error, LocalizedError {
    case unregistredApp
    case authError
    case retrievingURL
    case duringAdding

    var localizedDescription: String {
        switch self {
        case .unregistredApp:
            return "App not registred or configured"
        case .authError:
            return "Error during auth"
        case .retrievingURL:
            return "Error retrieve url from extension"
        case .duringAdding:
            return "Error during pushing to your wallabag server"
        }
    }
}
