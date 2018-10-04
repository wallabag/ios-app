//
//  Bool.swift
//  wallabag
//
//  Created by maxime marinel on 04/10/2018.
//

import Foundation

extension Bool {
    var int: Int {
        get {
            return self ? 1 : 0
        }
    }
}
