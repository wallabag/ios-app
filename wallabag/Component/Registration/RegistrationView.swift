//
//  RegistrationView.swift
//  wallabag
//
//  Created by Marinel Maxime on 18/07/2019.
//

import SwiftUI

struct RegistrationView: View {
    @State private var showBetaDisclamer: Bool = false

    var body: some View {
        NavigationView {
            VStack {
                Image("logo")
                Text("Wallabag").font(.title)
                NavigationLink("Log in", destination: ServerView())
            }.navigationBarHidden(true)
                .sheet(isPresented: $showBetaDisclamer, content: { BetaDisclaimerView() })
                .onAppear {
                    self.showBetaDisclamer = WallabagUserDefaults.showBetaDisclamer
                }
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
