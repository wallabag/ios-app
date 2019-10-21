//
//  EntryPublisher.swift
//  wallabag
//
//  Created by Marinel Maxime on 15/10/2019.
//

import Combine
import Foundation
import CoreData

class EntryPublisher: ObservableObject {
    @Published var retrieveMode: RetrieveMode = .allArticles {
        didSet {
            fetch()
        }
    }
    @Published var entries: [Entry] = []
    var hasChanges: Cancellable?
    @CoreDataViewContext var context: NSManagedObjectContext
    
    init() {
         hasChanges = context.publisher(for: \.hasChanges).sink { _ in
             self.fetch()
         }
    }
    
    func fetch() {
        do {
            entries = try context.fetch(Entry.fetchRequestSorted()).self
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
        /*try? realm.write {
            realm.delete(entry)
        }*/
    }

    deinit {
        hasChanges?.cancel()
    }
}
