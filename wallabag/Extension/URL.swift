//
//  URL.swift
//  wallabag
//
//  Created by Marinel Maxime on 28/03/2020.
//

import Foundation

extension URL: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self = URL(string: value)!
    }
}
