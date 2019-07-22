//
//  MainView.swift
//  wallabag
//
//  Created by Marinel Maxime on 18/07/2019.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        return ViewBuilder.buildBlock(
            appState.registred ?
            ViewBuilder.buildEither(second: ArticleListView()):
            ViewBuilder.buildEither(first: RegistrationView().environmentObject(appState))
        )
    }
}

#if DEBUG
struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        Text("nothing")
    }
}
#endif
