//
//  EntryPublisher.swift
//  wallabag
//
//  Created by Marinel Maxime on 15/10/2019.
//

import Combine
import CoreData
import Foundation

class EntryPublisher: ObservableObject {
    // BUG WORKAROUND
    let objectWillChange = ObservableObjectPublisher()
    // END BUG WORKAROUND

    @CoreDataViewContext var context: NSManagedObjectContext

    @Published var retrieveMode: RetrieveMode = .allArticles {
        willSet {
            objectWillChange.send()
        }
    }

    @Published var entries: [Entry] = [] {
        willSet {
            objectWillChange.send()
        }
    }

    private var hasChanges: Cancellable?

    init() {
        retrieveMode = RetrieveMode(fromCase: WallabagUserDefaults.defaultMode)
        _ = $retrieveMode.receive(on: RunLoop.main).sink { retrieveMode in
            print("observable change to \(retrieveMode)")
            self.fetch()
        }
    }

    func fetch() {
        do {
            let fetchRequest = Entry.fetchRequestSorted()
            fetchRequest.predicate = retrieveMode.predicate()
            entries = try context.fetch(fetchRequest)
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    func toggleArchive(_ entry: Entry) {
        entry.isArchived.toggle()
        entry.objectWillChange.send()
    }

    func toggleStar(_ entry: Entry) {
        entry.isStarred.toggle()
        entry.objectWillChange.send()
    }

    func delete(_ entry: Entry) {
        if let index = entries.firstIndex(of: entry) {
            context.delete(entry)
            entries.remove(at: index)
            objectWillChange.send()
        }
    }

    deinit {
        hasChanges?.cancel()
    }
}
