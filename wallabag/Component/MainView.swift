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
    @State private var showMenu: Bool = false

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
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                VStack {
                    if self.router.route.showHeader {
                        self.header.padding(.horizontal).padding(.top, 15)
                    }
                    ErrorView()
                    self.routedView()
                }.frame(width: geometry.size.width, height: geometry.size.height)
                    .offset(x: self.appState.showMenu ? geometry.size.width / 2 : 0)
                if self.appState.showMenu {
                    MenuView()
                        .frame(width: geometry.size.width / 2)
                        .transition(.move(edge: .leading))
                }
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
                .environmentObject(appState)).id("entriesView")
        case let .entry(entry):
            return AnyView(EntryView(entry: entry)).id("entryView")
        case .tips:
            return AnyView(TipView()).id("tipView")
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
