//
//  MenuView.swift
//  wallabag
//
//  Created by Marinel Maxime on 15/01/2020.
//

import SwiftUI

struct MenuView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        VStack(alignment: .leading) {
            Text("Menu")
                .font(.title)
                .fontWeight(.black)
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
                }
            }
            Spacer()
        }.padding()
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
