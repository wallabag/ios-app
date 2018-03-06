//
//  Created by maxime marinel on 02/02/2018.
//  Copyright © 2018 maxime marinel. All rights reserved.
//

import Foundation
import CoreData
import CoreSpotlight
import MobileCoreServices
import RealmSwift

extension ArticleSync {

    func spotLightIndex(_ entry: Entry) {
        NSLog("Spotlight entry \(entry.id)")
        let searchableItem = CSSearchableItem(uniqueIdentifier: entry.spotlightIdentifier,
                                              domainIdentifier: "entry",
                                              attributeSet: entry.searchableItemAttributeSet
        )
        CSSearchableIndex.default().indexSearchableItems([searchableItem]) { (error) -> Void in
            if error != nil {
                NSLog(error!.localizedDescription)
            }
        }
    }

    func spotLightDelete(_ entry: Entry) {
        CSSearchableIndex.default().deleteSearchableItems(withIdentifiers: [entry.spotlightIdentifier], completionHandler: nil)
    }
}
