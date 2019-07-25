//
//  MainView.swift
//  wallabag
//
//  Created by Marinel Maxime on 18/07/2019.
//

import SwiftUI
import WallabagKit
import Combine

class AppSync: BindableObject {
    let didChange = PassthroughSubject<Void, Never>()
    
    var inProgress = false
    
    func sync() {
        let kit = WallabagKit(
            host: WallabagUserDefaults.host,
            clientID: WallabagUserDefaults.clientId,
            clientSecret: WallabagUserDefaults.clientSecret
        )
        kit.requestAuth(
            username: WallabagUserDefaults.login,
            password: WallabagUserDefaults.password
        ) { auth in
            switch auth {
            case .success:
                let sync = WallabagSyncing(kit: kit)
                sync.kit = kit
                sync.sync {
                    
                }
            case .error(_):
                break
            case .invalidParameter:
                break
            case .unexpectedError:
                break
            }
            print(auth)
            /*[weak self] auth in
             
            switch auth {
            case .success:
                self?.currentState = .connected
            case let .error(error):
                Log(error)
                self?.currentState = .error
            case .invalidParameter, .unexpectedError:
                self?.currentState = .error
            }*/
        }
        
        
    }
}

struct MainView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        return ViewBuilder.buildBlock(
            appState.registred ?
            ViewBuilder.buildEither(second: ArticleListView().environmentObject(AppSync())) :
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
