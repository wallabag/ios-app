//
//  RefreshButton.swift
//  wallabag
//
//  Created by Marinel Maxime on 18/10/2019.
//

import SwiftUI

struct RefreshButton: View {
    @EnvironmentObject var appSync: AppSync

    var body: some View {
        HStack {
            if appSync.inProgress {
                Text("\(Int(appSync.progress))%")
            }

            Button(
                action: appSync.requestSync,
                label: {
                    Image(systemName: "arrow.counterclockwise")
                        .frame(width: 34, height: 34, alignment: .center)
                        .rotationEffect(.degrees(appSync.inProgress ? 0 : 360))
                        .animation(Animation.spring().repeatForever(autoreverses: false))
                }
            ).disabled(appSync.inProgress)
        }
    }
}

struct RefreshButton_Previews: PreviewProvider {
    static var previews: some View {
        RefreshButton().environmentObject(AppSync())
    }
}
