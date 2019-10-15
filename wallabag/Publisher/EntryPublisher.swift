//
//  EntryPublisher.swift
//  wallabag
//
//  Created by Marinel Maxime on 15/10/2019.
//

import Combine
import Foundation
import RealmSwift

class EntryPublisher: ObservableObject {
    @Injector var realm: Realm
    @Published var retrieveMode: RetrieveMode = .allArticles {
        didSet {
            loadEntries()
        }
    }

    @Published var entries: [Entry] = []

    private var notificationToken: NotificationToken?

    func loadEntries() {
        let results = realm.objects(Entry.self)
        notificationToken = results.observe { changes in
            switch changes {
            case let .update(results, _, _, _):
                self.entries = results.compactMap { $0 }
            case .initial:
                break
            case .error:
                break
            }
        }
        entries = results.filter(retrieveMode.predicate()).compactMap { $0 }
    }

    func start(entry: Entry) {
        try? realm.write {
            entry.isStarred = true
        }
    }

    deinit {
        notificationToken?.invalidate()
    }
}
