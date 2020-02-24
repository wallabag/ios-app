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
                if router.route.showHeader {
                    header.padding(.horizontal).padding(.top, 15)
                }
                ErrorView()
                routedView()
            }
        }
    }

    private func routedView() -> some View {
        switch router.route {
        case .addEntry:
            return AnyView(AddEntryView()).id("addEntryView")
        case .about:
            return AnyView(AboutView()).id("aboutView")
        case .entries:
            return AnyView(EntriesView()
                .environmentObject(AppSync())
                .environmentObject(appState)).id("entriesView")
        case .tips:
            return AnyView(TipView()).id("tipView")
        case .none:
            return AnyView(Text("Never")).id("Never")
        case let .entry(entry):
            return AnyView(EntryView(entry: entry)).id("entryView")
        case .registration:
            return AnyView(RegistrationView().environmentObject(appState)).id("Registration")
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
