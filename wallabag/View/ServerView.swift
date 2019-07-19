//
//  ServerView.swift
//  wallabag
//
//  Created by Marinel Maxime on 18/07/2019.
//

import SwiftUI
import Combine

class ServerValidator: BindableObject {
    let didChange = PassthroughSubject<Void, Never>()
    var isValid: Bool = false {
        didSet {
            didChange.send()
        }
    }
    var url: String = "" {
        didSet {
            validate(url: url)
        }
    }
    
    func validate(url: String) {
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
            /* WallabagKit.getVersion(from: string) { version in
             Log("Server version \(version)")
             completion(version.supportedVersion != .unsupported)
             } */
        } catch {
            return false
        }
    }
}

struct ServerView: View {
    @ObjectBinding var serverValidator = ServerValidator()
    
    var body: some View {
        Form {
            Section(header: Text("Server")) {
                TextField($serverValidator.url)
            }
            NavigationLink("Next", destination: ClientIdClientSecretView()).disabled(!serverValidator.isValid)
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
