import os
import SwiftUI

let logger = Logger(subsystem: "fr.district-web.wallabag", category: "main")

@main
struct WallabagMacApp: App {
    @StateObject var appState = AppState.shared

    var body: some Scene {
        WindowGroup {
            NavigationView {
                SidebarView()
                List {}
                RouterView()
            }.environment(\.managedObjectContext, CoreData.shared.viewContext)
                .environmentObject(Router.shared)
        }
    }
}
