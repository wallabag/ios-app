import Combine
import Foundation
import UIKit

class PasteBoardViewModel: ObservableObject {
    @Published var showPasteBoardView: Bool = false {
        willSet {
            if newValue {
                WallabagUserDefaults.previousPasteBoardUrl = UIPasteboard.general.url?.absoluteString ?? ""
                pasteBoardUrl = UIPasteboard.general.url?.absoluteString ?? ""
            }
        }
    }

    @Published var pasteBoardUrl: String = ""
    @Injector var session: WallabagSession

    private var cancellableNotification: AnyCancellable?

    init() {
        cancellableNotification = NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)
            .map { _ -> Bool in
                guard let pasteBoardUrl = UIPasteboard.general.url,
                      pasteBoardUrl.absoluteString != WallabagUserDefaults.previousPasteBoardUrl
                else {
                    return false
                }
                return true
            }
            .assign(to: \.showPasteBoardView, on: self)
    }

    deinit {
        cancellableNotification?.cancel()
    }

    func addUrl() {
        session.addEntry(url: pasteBoardUrl) {}
        showPasteBoardView = false
    }

    func hide() {
        showPasteBoardView = false
    }
}
