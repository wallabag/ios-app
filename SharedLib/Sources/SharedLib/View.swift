import Foundation
import SwiftUI

@available(iOS 13.0, *)
public extension View {
    func openInSafari(_ url: String?) {
        guard let path = url, let url = URL(string: path) else { return }
        UIApplication.shared.open(url)
    }
}
