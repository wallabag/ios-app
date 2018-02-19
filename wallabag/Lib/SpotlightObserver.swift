//
//  Created by maxime marinel on 02/02/2018.
//  Copyright © 2018 maxime marinel. All rights reserved.
//

import Foundation
import CoreData
import CoreSpotlight
import MobileCoreServices

final class SpotlightObserver {
    private let spotlightQueue = DispatchQueue(label: "fr.district-web.wallabag.spotlightQueue", qos: .background)

    init() {
        //NotificationCenter.default.addObserver(self, selector: #selector(objectDidChange), name: NSNotification.Name.NSManagedObjectContextObjectsDidChange, object: CoreData.context)
    }

    @objc func objectDidChange(notification: Notification) {
        guard let userInfo = notification.userInfo else { return }

        if let inserts = userInfo[NSInsertedObjectsKey] as? Set<NSManagedObject>, !inserts.isEmpty {
            if let entry = inserts.first as? Entry {
                index(entry: entry)
            }
        }

        if let updates = userInfo[NSUpdatedObjectsKey] as? Set<NSManagedObject>, !updates.isEmpty {
            if let entry = updates.first as? Entry {
                index(entry: entry)
            }
        }

        if let deletes = userInfo[NSDeletedObjectsKey] as? Set<NSManagedObject>, !deletes.isEmpty {
            if let entry = deletes.first as? Entry {
                spotlightQueue.async {
                    CSSearchableIndex.default().deleteSearchableItems(withIdentifiers: [entry.spotlightIdentifier], completionHandler: nil)
                }
            }
        }
    }

    private func index(entry: Entry) {
        spotlightQueue.async {
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
    }
}
