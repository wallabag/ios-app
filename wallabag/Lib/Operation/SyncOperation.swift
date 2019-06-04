//
//  SyncOperation.swift
//  wallabag
//
//  Created by maxime marinel on 20/01/2018.
//  Copyright © 2018 maxime marinel. All rights reserved.
//

import CoreSpotlight
import Foundation
import RealmSwift
import WallabagKit

final class SyncOperation: Operation {
    enum State: String {
        case ready = "Ready"
        case executing = "Executing"
        case finished = "Finished"
        fileprivate var keyPath: String { return "is" + rawValue }
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
        if isCancelled {
            state = .finished
        } else {
            state = .ready
            main()
        }
    }

    override func main() {
        if isCancelled {
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
                    #warning("@TODO clean cascade of if")
                    if let entry = realm.object(ofType: Entry.self, forPrimaryKey: wallabagEntry.id) {
                        if let articleUpdatedAt = Date.fromISOString(wallabagEntry.updatedAt) {
                            if entry.updatedAt! > articleUpdatedAt {
                                update(entry: entry)
                            }
                        }
                    }

                    let entry = Entry()
                    entry.hydrate(from: wallabagEntry)
                    realm.add(entry, update: .modified)

                    updateSpotlight(entry)
                }
                try realm.commitWrite()
            } catch _ {
                Log("error")
            }
        }
    }

    private func updateSpotlight(_ entry: Entry) {
        #warning("@TODO move spotlight to an observer")
        let searchableItem = CSSearchableItem(uniqueIdentifier: entry.spotlightIdentifier,
                                              domainIdentifier: "entry",
                                              attributeSet: entry.searchableItemAttributeSet)
        CSSearchableIndex.default().indexSearchableItems([searchableItem]) { (error) -> Void in
            if error != nil {
                Log(error!.localizedDescription)
            }
        }
    }

    private func update(entry: Entry) {
        kit.entry(
            update: entry.id,
            parameters: [
                "archive": entry.isArchived.int,
                "starred": entry.isStarred.int,
            ], queue: nil
        ) { _ in
            Log("Update from local to server")
        }
    }
}
