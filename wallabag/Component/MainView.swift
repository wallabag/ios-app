//
//  MainView.swift
//  wallabag
//
//  Created by Marinel Maxime on 18/07/2019.
//

import Combine
import SwiftUI

struct MainView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var playerPublisher: PlayerPublisher

    var body: some View {
        VStack {
            ViewBuilder.buildBlock(
                appState.registred ?
                    ViewBuilder.buildEither(second: EntriesView()
                        .environmentObject(AppSync())
                        .environmentObject(appState)
                        .environmentObject(EntryPublisher())) :
                    ViewBuilder.buildEither(first: RegistrationView().environmentObject(appState)))
            if playerPublisher.showPlayer && appState.registred {
                PlayerView()
            }
        }
    }
}

#if DEBUG
    struct MainView_Previews: PreviewProvider {
        static var previews: some View {
            Text("nothing")
        }
    }
#endif
