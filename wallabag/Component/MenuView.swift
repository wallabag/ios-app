//
//  MenuView.swift
//  wallabag
//
//  Created by Marinel Maxime on 15/01/2020.
//

import SwiftUI

struct MenuView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var router: Router

    // swiftlint:disable multiple_closures_with_trailing_closure
    var body: some View {
        VStack(alignment: .leading) {
            Text("Menu")
                .font(.title)
                .fontWeight(.black)

            HStack {
                Button(action: {
                    self.router.route = .entries
                }) {
                    Image(systemName: "tray.full")
                    Text("Entries")
                }
            }
            HStack {
                Button(action: {
                    self.router.route = .addEntry
                }) {
                    Image(systemName: "tray.and.arrow.down")
                    Text("Add entry")
                }
            }
            HStack {
                Button(action: {
                    self.router.route = .about
                }) {
                    Image(systemName: "questionmark")
                    Text("About")
                }
            }
            HStack {
                Button(action: {
                    self.router.route = .tips
                }) {
                    Image(systemName: "heart")
                    Text("Tips")
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
