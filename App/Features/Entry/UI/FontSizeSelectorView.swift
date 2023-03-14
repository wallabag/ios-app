import Foundation
import SwiftUI

struct FontSizeSelectorView: View {
    @State private var showSelector: Bool = false
    @EnvironmentObject var appSetting: AppSetting

    var body: some View {
        HStack {
            Button(action: {
                withAnimation {
                    self.showSelector = !self.showSelector
                }
            }, label: {
                Image(systemName: "textformat.size")
            })
            if showSelector {
                Slider(value: $appSetting.webFontSizePercent, in: 50 ... 200, step: 10)
                    .frame(width: 150)
                    .accessibilityLabel("Text size")
                    .accessibilityHint("Change entry text size")
            }
        }
    }
}
