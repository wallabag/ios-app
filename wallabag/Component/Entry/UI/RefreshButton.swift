//
//  RefreshButton.swift
//  wallabag
//
//  Created by Marinel Maxime on 18/10/2019.
//

import SwiftUI

#warning("Need rework")
struct RefreshButton: View {
    @ObservedObject var appSync: AppSync
    @State private var refreshing: Bool = false

    var body: some View {
        Button(
            action: {
                self.refreshing = true
                self.appSync.requestSync {
                    self.refreshing = false
                }
            },
            label: {
                Image(systemName: "arrow.counterclockwise")
                    .frame(width: 34, height: 34, alignment: .center)
                    .rotationEffect(.degrees(refreshing ? 0 : 360))
                    .animation(Animation.spring().repeatForever(autoreverses: false))
            }
        ).disabled(refreshing)
    }
}

struct RefreshButton_Previews: PreviewProvider {
    static var previews: some View {
        RefreshButton(appSync: AppSync())
    }
}
