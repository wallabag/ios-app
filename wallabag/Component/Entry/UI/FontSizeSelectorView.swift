//
//  FontSizeSelectorView.swift
//  wallabag
//
//  Created by Marinel Maxime on 27/05/2020.
//

import Foundation
import SwiftUI

struct FontSizeSelectorView: View {
    @State private var showSelector: Bool = false
    @EnvironmentObject var appSetting: AppSetting

    var body: some View {
        VStack {
            if showSelector {
                Slider(value: $appSetting.webFontSizePercent, in: 50 ... 200, step: 25)
                    .frame(width: 150)
            }
            Button(action: {
                withAnimation {
                    self.showSelector = !self.showSelector
                }
            }, label: {
                Image(systemName: "textformat.size")
            })
        }
    }
}
