//
//  ServerView.swift
//  wallabag
//
//  Created by Marinel Maxime on 18/07/2019.
//

import SwiftUI
import Combine

class ServerValidator: BindableObject {
    let didChange = PassthroughSubject<ServerValidator, Never>()
    @Published var isValid: Bool = false {
        didSet {
            didChange.send(self)
        }
    }
    var url: String = "" {
        didSet {
            validate(url: url)
        }
    }
    
    private func validate(url: String) {
        isValid = validateServer(string: url)
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
    deinit {
        print("by")
    }
}

struct ServerView: View {
    @ObjectBinding var validator = ServerValidator()
    
    init() {
        validator.$isValid.sink { [unowned validator] isValid in
            if(isValid){
                WallabagUserDefaults.host = validator.url
            }
        }
    }
    
    var body: some View {
        Form {
            Section(header: Text("Server")) {
                TextField($validator.url)
            }.onAppear {
                self.validator.url = WallabagUserDefaults.host
            }
            NavigationLink(destination: ClientIdClientSecretView()) {
               Text("Next")
            }.disabled(!validator.isValid)
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
