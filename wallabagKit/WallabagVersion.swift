//
//  WallabagVersion.swift
//  wallabag
//
//  Created by maxime marinel on 11/09/2018.
//

import Foundation

public struct WallabagVersion {
    public enum SupportedVersion: String {
        case v2dot3dot5 = "\"2.3.5\""
        case v2dot3dot4 = "\"2.3.4\""
        case v2dot3dot3 = "\"2.3.3\""
        case v2dot3dot2 = "\"2.3.2\""
        case unsupported
    }

    public let version: String
    public let supportedVersion: SupportedVersion

    init(version: String) {
        self.version = version
        supportedVersion = SupportedVersion(rawValue: version) ?? .unsupported
    }
}
