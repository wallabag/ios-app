//
//  SyncOperation.swift
//  wallabag
//
//  Created by maxime marinel on 20/01/2018.
//  Copyright © 2018 maxime marinel. All rights reserved.
//

import Foundation
import WallabagKit
import RealmSwift
import CoreSpotlight

final class SyncOperation: Operation {
    enum State: String {
        case ready = "Ready"
        case executing = "Executing"
        case finished = "Finished"
        fileprivate var keyPath: String { return "is" + self.rawValue }
    }

    override var isAsynchronous: Bool { return true }
    override var isExecuting: Bool { return state == .executing }
    override var isFinished: Bool { return state == .finished }

    var state = State.ready {
        willSet {
            willChangeValue(forKey: state.keyPath)
            willChangeValue(forKey: newValue.keyPath)
        }
        didSet {
            didChangeValue(forKey: state.keyPath)
            didChangeValue(forKey: oldValue.keyPath)
        }
    }
    var entries: WallabagKitCollection<WallabagKitEntry>?
    let kit: WallabagKitProtocol

    init(kit: WallabagKitProtocol) {
        self.kit = kit
    }

    func setEntries(_ entries: WallabagKitCollection<WallabagKitEntry>) {
        self.entries = entries
    }

    override func start() {
        if self.isCancelled {
            state = .finished
        } else {
            state = .ready
            main()
        }
    }

    override func main() {
        if self.isCancelled {
            state = .finished
        } else {
            state = .executing
            defer {
                state = .finished
            }
            do {
                guard let entries = entries?.items else { return }
                let realm = try Realm()
                realm.beginWrite()
                for wallabagEntry in entries {
                    if let entry = realm.object(ofType: Entry.self, forPrimaryKey: wallabagEntry.id) {
                        self.update(entry: entry, from: wallabagEntry)
                    } else {
                        self.insert(wallabagEntry, realm)
                    }
                }
                try realm.commitWrite()
            } catch _ {
                Log("error")
            }
        }
    }

    private func insert(_ wallabagEntry: WallabagKitEntry, _ realm: Realm) {
        let entry = Entry()
        Log("Insert article \(wallabagEntry.id)")
        entry.hydrate(from: wallabagEntry)
        realm.add(entry)

        #warning("@TODO move spotlight to an observer")
        let searchableItem = CSSearchableItem(uniqueIdentifier: entry.spotlightIdentifier,
                                              domainIdentifier: "entry",
                                              attributeSet: entry.searchableItemAttributeSet
        )
        CSSearchableIndex.default().indexSearchableItems([searchableItem]) { (error) -> Void in
            if error != nil {
                Log(error!.localizedDescription)
            }
        }
    }

    private func update(entry: Entry, from article: WallabagKitEntry) {
        let articleUpdatedAt = Date.fromISOString(article.updatedAt) ?? Date()
        if entry.updatedAt != articleUpdatedAt {
            if articleUpdatedAt > entry.updatedAt! {
                entry.hydrate(from: article)
            } else {
                update(entry: entry)
            }
        }
    }

    private func update(entry: Entry) {
        kit.entry(
            update: entry.id,
            parameters: [
                "archive": entry.isArchived.hashValue,
                "starred": entry.isStarred.hashValue
        ], queue: nil) { _ in
            Log("Update from local to server")
        }
    }
}
