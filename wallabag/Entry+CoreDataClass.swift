//
//  Entry+CoreDataClass.swift
//  wallabag
//
//  Created by maxime marinel on 08/05/2017.
//  Copyright © 2017 maxime marinel. All rights reserved.
//

import Foundation
import CoreData

@objc(Entry)
public class Entry: NSManagedObject {
    var spotlightIdentifier: String {
        return "\(Bundle.main.bundleIdentifier!).spotlight.\(Int(id))"
    }
}
