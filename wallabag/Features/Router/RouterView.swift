//
//  RouterView.swift
//  wallabag
//
//  Created by Marinel Maxime on 01/05/2020.
//

import Foundation
import SwiftUI

struct RouterView<RootView>: View where RootView: View {
    @EnvironmentObject var router: Router

    var rootView: RootView

    init(@ViewBuilder rootView: () -> RootView) {
        self.rootView = rootView()
    }

    var body: some View {
        Group {
            if router.currentView == nil {
                rootView
            } else {
                router.currentView?.wrappedView.id(router.currentView?.id)
            }
        }
    }
}
