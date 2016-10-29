//
//  Dictionary.swift
//  wallabag
//
//  Created by maxime marinel on 29/10/2016.
//  Copyright © 2016 maxime marinel. All rights reserved.
//

import Foundation

extension Dictionary {
    func merge(dict: Dictionary<Key, Value>) -> Dictionary<Key, Value> {
        var mutableCopy = self
        for (key, value) in dict {
            // If both dictionaries have a value for same key, the value of the other dictionary is used.
            mutableCopy[key] = value
        }
        return mutableCopy
    }
}
