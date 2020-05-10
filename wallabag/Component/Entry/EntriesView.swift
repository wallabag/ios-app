//
//  ArticleListView.swift
//  wallabag
//
//  Created by Marinel Maxime on 11/07/2019.
//

import Combine
import CoreData
import SwiftUI

class SearchPublisher: ObservableObject {
    @Published var search: String = ""
    @Published var retrieveMode: RetrieveMode = RetrieveMode(fromCase: WallabagUserDefaults.defaultMode)

    @Published var predicate: NSPredicate = NSPredicate(value: true)

    var cancellable = Set<AnyCancellable>()

    init() {
        let searchThrottle = $search
            .debounce(for: 1.5, scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
            
        Publishers.CombineLatest($retrieveMode, searchThrottle)
            .receive(on: DispatchQueue.main)
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

struct SearchView: View {
    @ObservedObject var searchPublisher: SearchPublisher
    var body: some View {
        VStack {
            if searchPublisher.search == "" {
                RetrieveModePicker(filter: $searchPublisher.retrieveMode)
            }
            HStack {
                Image(systemName: "magnifyingglass")
                TextField("Search", text: $searchPublisher.search)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)

            }.padding(.horizontal)
        }
    }
}

struct EntriesView: View {
    @ObservedObject var pasteBoardPublisher = PasteBoardPublisher()
    @ObservedObject var searchPublisher = SearchPublisher()

    var body: some View {
        VStack {
            // MARK: Pasteboard

            if pasteBoardPublisher.showPasteBoardView {
                PasteBoardView().environmentObject(pasteBoardPublisher)
            }

            // MARK: Picker

            SearchView(searchPublisher: searchPublisher)
            EntriesListView(predicate: searchPublisher.predicate)
            // PlayerView()
        }
        .navigationBarTitle(Text("Entry"))
        .navigationBarHidden(true)
    }
}

#if DEBUG
    struct ArticleListView_Previews: PreviewProvider {
        static var previews: some View {
            EntriesView()
                .environmentObject(PasteBoardPublisher())
        }
    }
#endif
