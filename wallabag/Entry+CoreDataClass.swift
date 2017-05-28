//
//  Entry+CoreDataClass.swift
//  wallabag
//
//  Created by maxime marinel on 08/05/2017.
//  Copyright © 2017 maxime marinel. All rights reserved.
//

import Foundation
import CoreData
import CoreSpotlight
import MobileCoreServices

@objc(Entry)
public class Entry: NSManagedObject {
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
