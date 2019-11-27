//
//  RefreshButton.swift
//  wallabag
//
//  Created by Marinel Maxime on 18/10/2019.
//

import SwiftUI

struct RefreshButton: View {
    @EnvironmentObject var appSync: AppSync
    @EnvironmentObject var entryPublisher: EntryPublisher

    var body: some View {
        Button(
            action: {
                self.appSync.requestSync {
                    self.entryPublisher.fetch()
                }
            },
            label: {
                Image(systemName: "arrow.counterclockwise")
                    .frame(width: 34, height: 34, alignment: .center)
                    .rotationEffect(.degrees(appSync.inProgress ? 0 : 360))
                    .animation(Animation.spring().repeatForever(autoreverses: false))
            }
        ).disabled(appSync.inProgress)
    }
}

struct RefreshButton_Previews: PreviewProvider {
    static var previews: some View {
        RefreshButton()
            .environmentObject(AppSync())
            .environmentObject(EntryPublisher())
    }
}
