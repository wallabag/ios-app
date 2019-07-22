//
//  MainView.swift
//  wallabag
//
//  Created by Marinel Maxime on 18/07/2019.
//

import SwiftUI

struct MainView: View {
    @State var registration: Bool = true
    @EnvironmentObject var setting: Sett
    
    var body: some View {
        return ViewBuilder.buildBlock(registration ? ViewBuilder.buildEither(first: RegistrationView().environmentObject(setting)) : ViewBuilder.buildEither(second: ArticleListView()), Button("Tap", action: {self.registration.toggle()}))
    }
}

#if DEBUG
struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        Text("nothing")
    }
}
#endif
