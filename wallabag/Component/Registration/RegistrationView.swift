//
//  RegistrationView.swift
//  wallabag
//
//  Created by Marinel Maxime on 18/07/2019.
//

import SwiftUI

struct RegistrationView: View {
    var body: some View {
        NavigationView {
            VStack {
                Image("logo")
                Text("Wallabag").font(.title)
                NavigationLink("Register", destination: ServerView())
            }.navigationBarHidden(true)
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

#if DEBUG
    struct RegistrationView_Previews: PreviewProvider {
        static var previews: some View {
            RegistrationView()
        }
    }
#endif
