//
//  WallabagSyncing.swift
//  wallabag
//
//  Created by maxime marinel on 24/09/2018.
//

import Foundation
import WallabagKit
import RealmSwift

class WallabagSyncing {
    private let kit: WallabagKitProtocol
    private let dispatchQueue = DispatchQueue(label: "fr.district-web.wallabag.articleSyncQueue", qos: .utility)
    private var operationQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.name = "Sync operation queue"
        queue.qualityOfService = .utility
        return queue
    }()
    private let group = DispatchGroup()
    private var entriesSynced: [Int] = []
    var progress: ((Int, Int) -> Void)?

    init(kit: WallabagKitProtocol) {
        self.kit = kit
    }

    func sync(completion: @escaping () -> Void) {
        entriesSynced = []
        fetchEntry(page: 1)
        group.notify(queue: dispatchQueue) { [unowned self] in
            Log("Sync terminated")
            self.purge()
            completion()
        }
    }

    private func fetchEntry(page: Int) {
        group.enter()
        Log("fetch \(page)")
        kit.entry(parameters: ["page": page], queue: dispatchQueue) { [unowned self] response in
            switch response {
            case .success(let entries):
                entries.items.forEach({self.entriesSynced.append($0.id)})

                let syncOperation = SyncOperation(entries: entries, kit: self.kit)
                self.operationQueue.addOperation(syncOperation)
                if page < entries.pages {
                    self.fetchEntry(page: page + 1)
                }
                syncOperation.completionBlock = {
                    self.group.leave()
                    self.progress?(page, entries.pages)
                }
            case .error:
                Log("Fetch error")
            }
        }
    }

    private func purge() {
        dispatchQueue.async { [unowned self] in
            do {
                let realmPurge = try Realm()
                try realmPurge.write {
                    let entries = realmPurge.objects(Entry.self).filter("NOT (id IN %@)", self.entriesSynced)
                    realmPurge.delete(entries)
                }
            } catch _ {

            }
        }
    }
}
