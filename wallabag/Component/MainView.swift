//
//  MainView.swift
//  wallabag
//
//  Created by Marinel Maxime on 18/07/2019.
//

import Combine
import SwiftUI

class AppSync: ObservableObject {
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
        _ = session.kit.send(decodable: WallabagCollection<WallabagEntry>.self, to: WallabagEntryEndpoint.get)
            .sink(receiveCompletion: { completion in
                print(completion)
                if case .failure = completion {}
            }, receiveValue: { entries in
                Log(entries)
            })

        DispatchQueue.global().asyncAfter(deadline: .now() + 2) { self.inProgress = false }
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
