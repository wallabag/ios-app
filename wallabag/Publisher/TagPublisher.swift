//
//  TagPublisher.swift
//  wallabag
//
//  Created by Marinel Maxime on 23/10/2019.
//

import Foundation
import Combine
import CoreData

class TagPublisher: ObservableObject {
    //BUG WORKAROUND
    let objectWillChange = ObservableObjectPublisher()
    //END BUG WORKAROUND
    
    @CoreDataViewContext var context: NSManagedObjectContext
    
    @Published var tags: [Tag] = []
    
    private var hasChanges: Cancellable?
    
    init() {
        hasChanges = context.publisher(for: \.hasChanges).sink { _ in
            self.fetch()
        }
    }
    
    func fetch() {
        do {
            tags = try context.fetch(Tag.fetchRequestSorted())
            objectWillChange.send()
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
