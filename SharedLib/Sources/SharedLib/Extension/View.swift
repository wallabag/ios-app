import Foundation
import SwiftUI

@available(iOS 13.0, macOS 10.15, *)
public extension View {
    func openInSafari(_ url: String?) {
        guard let path = url, let url = URL(string: path) else { return }
        #if os(iOS)
            UIApplication.shared.open(url)
        #endif
    }
}
