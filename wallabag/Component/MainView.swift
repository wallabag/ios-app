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
    @EnvironmentObject var router: Router
    @EnvironmentObject var errorPublisher: ErrorPublisher

    var header: some View {
        HStack {
            if router.route.showMenuButton {
                Button(action: {
                    withAnimation {
                        self.appState.showMenu.toggle()
                    }
                }, label: { Image(systemName: "list.bullet") })
            }
            Text(router.route.title)
                .font(.title)
                .fontWeight(.black)
            Spacer()
            if router.route.showTraillingButton {
                router.route.traillingButton
            }
        }
    }

    var body: some View {
        HStack {
            if appState.showMenu {
                MenuView()
            }
            VStack {
                header.padding(.horizontal).padding(.top, 15)
                ErrorView()
                if router.route == .tips {
                    TipView()
                } else if router.route == .addEntry {
                    AddEntryView()
                } else if router.route == .about {
                    AboutView()
                } else if router.route == .entries {
                    EntriesView()
                        .environmentObject(AppSync())
                        .environmentObject(appState)
                    PlayerView()
                } else if router.route == .registration {
                    RegistrationView().environmentObject(appState)
                }
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
