//
//  MenuView.swift
//  wallabag
//
//  Created by Marinel Maxime on 15/01/2020.
//

import SwiftUI

private struct Menu {
    let title: String
    let img: String
    let route: Route
}

struct MenuView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var router: Router

    fileprivate let menus: [Menu] = [
        .init(title: "Entries", img: "tray.full", route: .entries),
        .init(title: "Add entry", img: "tray.and.arrow.down", route: .addEntry),
        .init(title: "About", img: "questionmark", route: .about),
        .init(title: "Tips", img: "heart", route: .tips),
    ]

    // swiftlint:disable multiple_closures_with_trailing_closure
    var body: some View {
        VStack(alignment: .leading) {
            Text("Menu")
                .font(.title)
                .fontWeight(.black)
            ForEach(menus, id: \.title) { menu in
                HStack {
                    Button(action: {
                        self.router.route = menu.route
                    }) {
                        Image(systemName: menu.img)
                            .frame(width: 24)
                        Text(menu.title)
                    }
                }
            }
            Spacer()
            HStack {
                Button(action: {
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
                }) {
                    Image(systemName: "gear")
                    Text("Setting")
                }
            }
            HStack {
                Button(action: {
                    self.appState.logout()
                }) {
                    Image(systemName: "person")
                    Text("Logout")
                }.foregroundColor(.red)
            }
        }.padding()
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
