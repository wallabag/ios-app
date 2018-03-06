//
//  EntryExtension.swift
//  wallabag
//
//  Created by maxime marinel on 27/02/2018.
//  Copyright © 2018 maxime marinel. All rights reserved.
//

import Foundation
import CoreSpotlight
import MobileCoreServices

extension Entry {
    var spotlightIdentifier: String {
        return "\(Bundle.main.bundleIdentifier!).spotlight.\(Int(id))"
    }

    var searchableItemAttributeSet: CSSearchableItemAttributeSet {
        let searchableItemAttributeSet = CSSearchableItemAttributeSet(itemContentType: kUTTypeText as String)
        searchableItemAttributeSet.title = title
        searchableItemAttributeSet.contentDescription = content?.withoutHTML

        return searchableItemAttributeSet
    }
}
