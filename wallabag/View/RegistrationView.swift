//
//  RegistrationView.swift
//  wallabag
//
//  Created by Marinel Maxime on 18/07/2019.
//

import SwiftUI

struct RegistrationView: View {
    @EnvironmentObject var setting: Sett
    
    var body: some View {
        NavigationView {
            VStack {
                Image("logo")
                Text("Wallabag")
                    .font(.title)
                NavigationLink("Register", destination: ServerView().environmentObject(setting))
            }.navigationBarHidden(true)
        }
    }
}

#if DEBUG
struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        Text("nothing")
    }
}
#endif
