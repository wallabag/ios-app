//
//  SearchViewModel.swift
//  wallabag
//
//  Created by Marinel Maxime on 14/05/2020.
//

import Combine
import Foundation

class SearchViewModel: ObservableObject {
    @Published var search: String = ""
    @Published var retrieveMode: RetrieveMode = RetrieveMode(fromCase: WallabagUserDefaults.defaultMode)

    @Published var predicate: NSPredicate = NSPredicate(value: true)

    var cancellable = Set<AnyCancellable>()

    init() {
        let searchThrottle = $search
            .debounce(for: 1.5, scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()

        Publishers.CombineLatest($retrieveMode, searchThrottle)
            .sink { retrieveMode, search in
                if search != "" {
                    let predicateTitle = NSPredicate(format: "title CONTAINS[cd] %@", search)
                    let predicateContent = NSPredicate(format: "content CONTAINS[cd] %@", search)

                    let predicateCompound = NSCompoundPredicate(orPredicateWithSubpredicates: [predicateTitle, predicateContent])
                    self.predicate = predicateCompound
                } else {
                    self.predicate = retrieveMode.predicate()
                }
            }.store(in: &cancellable)
    }
}
