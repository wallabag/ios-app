//
//  SwipePlayerView.swift
//  wallabag
//
//  Created by Marinel Maxime on 25/11/2019.
//

import SwiftUI

struct SwipePlayerView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        Rectangle()
            .foregroundColor(.gray)
            .frame(width: 40, height: 5, alignment: .center)
            .cornerRadius(5)
            .gesture(DragGesture().onEnded { value in
                if value.startLocation.y > value.location.y {
                    self.appState.showPlayer = true
                } else {
                    self.appState.showPlayer = false
                }
            })
    }
}

struct SwipePlayerView_Previews: PreviewProvider {
    static var previews: some View {
        SwipePlayerView()
    }
}
