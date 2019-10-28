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
        didSet {
            fetch()
        }
    }

    @Published var entries: [Entry] = []

    private var hasChanges: Cancellable?

    init() {
        retrieveMode = RetrieveMode(fromCase: WallabagUserDefaults.defaultMode)
        hasChanges = context.publisher(for: \.updatedObjects).sink { objects in
            Log(objects)
        }
        /* hasChanges = context.publisher(for: \.hasChanges).sink { change in
             Log("Has change")
             self.fetch()
         } */
    }

    func fetch() {
        do {
            let fetchRequest = Entry.fetchRequestSorted()
            fetchRequest.predicate = retrieveMode.predicate()
            entries = try context.fetch(fetchRequest)
            objectWillChange.send()
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
