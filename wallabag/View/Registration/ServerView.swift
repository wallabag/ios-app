//
//  ServerView.swift
//  wallabag
//
//  Created by Marinel Maxime on 18/07/2019.
//

import SwiftUI
import Combine

class ServerHandler: BindableObject {
    let willChange = PassthroughSubject<ServerHandler, Never>()
    
    var isValid: Bool = false {
        didSet {
            willChange.send(self)
        }
    }
    var url: String = "" {
        didSet {
            handle(url: url)
        }
    }
    
    private func handle(url: String) {
        isValid = validateServer(string: url)
        if (isValid) {
           WallabagUserDefaults.host = url
        }
    }
    
    private func validateServer(string: String) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: "(http|https)://", options: [])
            guard let url = URL(string: string),
                UIApplication.shared.canOpenURL(url),
                1 == regex.matches(in: string, options: [], range: NSRange(location: 0, length: string.count)).count else {
                    return false
            }
            return true
        } catch {
            return false
        }
    }
}

struct ServerView: View {
    @EnvironmentObject var appState: AppState
    @ObjectBinding var serverHandler = ServerHandler()
    
    var body: some View {
        Form {
            Section(header: Text("Server")) {
                TextField($serverHandler.url)
            }.onAppear {
                self.serverHandler.url = WallabagUserDefaults.host
            }
            NavigationLink(destination: ClientIdClientSecretView().environmentObject(appState)) {
               Text("Next")
            }.disabled(!serverHandler.isValid)
        }
    }
}

#if DEBUG
struct ServerView_Previews: PreviewProvider {
    static var previews: some View {
        ServerView()
    }
}
#endif
