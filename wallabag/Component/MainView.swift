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
    @State private var showMenu: Bool = false
    
    var body: some View {
        VStack {
            ViewBuilder.buildBlock(
                appState.registred ?
                    ViewBuilder.buildEither(second: HStack {
                        if self.showMenu {
                            MenuView()
                        }
                        EntriesView(showMenu: self.$showMenu)
                            .environmentObject(AppSync())
                            .environmentObject(appState)
                            .environmentObject(EntryPublisher())
                    }) :
                    ViewBuilder.buildEither(first: RegistrationView().environmentObject(appState)))
            PlayerView()
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
