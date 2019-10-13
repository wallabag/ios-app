//
//  MainView.swift
//  wallabag
//
//  Created by Marinel Maxime on 18/07/2019.
//

import Combine
import RealmSwift
import SwiftUI

class AppSync: ObservableObject {
    @Injector var realm: Realm

    let session: WallabagSession

    init() {
        session = WallabagSession()
    }

    deinit {
        sessionState?.cancel()
    }

    var sessionState: AnyCancellable?

    @Published var inProgress = false

    func requestSync() {
        inProgress = true
        sessionState = session.$state.sink { state in
            if state == .connected {
                self.sync()
            }
        }
        session.requestSession()
    }

    private func sync() {
        fetchEntries { collection in
            self.realm.beginWrite()
            for wallabagEntry in collection.items {
                if let entry = self.realm.object(ofType: Entry.self, forPrimaryKey: wallabagEntry.id) {}
                let entry = Entry()
                entry.hydrate(from: wallabagEntry)
                self.realm.add(entry, update: .modified)
            }
            try? self.realm.commitWrite()
        }

        DispatchQueue.global().asyncAfter(deadline: .now() + 2) { self.inProgress = false }
    }

    private func fetchEntries(page: Int = 1, completion: @escaping (WallabagCollection<WallabagEntry>) -> Void) {
        _ = session.kit.send(decodable: WallabagCollection<WallabagEntry>.self, to: WallabagEntryEndpoint.get(page: page, perPage: 1))
            .sink(receiveCompletion: { completion in
                print(completion)
                if case .failure = completion {}
            }, receiveValue: { collection in
                if collection.page < collection.pages {
                    self.fetchEntries(page: collection.page + 1) { completion($0) }
                }
                completion(collection)
            })
    }
}

struct MainView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        let appSync = AppSync()
        return ViewBuilder.buildBlock(
            appState.registred ?
                ViewBuilder.buildEither(second: ArticleListView().environmentObject(appSync)) :
                ViewBuilder.buildEither(first: RegistrationView().environmentObject(appState))
        )
    }
}

#if DEBUG
    struct MainView_Previews: PreviewProvider {
        static var previews: some View {
            Text("nothing")
        }
    }
#endif
