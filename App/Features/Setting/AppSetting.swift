import Combine
import Foundation
import SharedLib

final class AppSetting: ObservableObject {
    @Published var webFontSizePercent: Double

    private var cancellable = Set<AnyCancellable>()

    init() {
        webFontSizePercent = WallabagUserDefaults.webFontSizePercent

        $webFontSizePercent
            .sink(receiveValue: updateWebFontSizePercent)
            .store(in: &cancellable)
    }

    private func updateWebFontSizePercent(_ value: Double) {
        WallabagUserDefaults.webFontSizePercent = value
    }
}
