import SwiftUI

struct WallabagPlusProtectedModifier: ViewModifier {
    @Environment(WallabagPlusStore.self) private var wallabagPlusStore

    func body(content: Content) -> some View {
        VStack {
            if wallabagPlusStore.proUnlocked {
                content
            } else {
                Image("logo")
                    .resizable()
                    .scaledToFit()
                Text("Sorry, this feature require you subscribe to wallabag Plus")
                    .fontDesign(.rounded)
            }
        }
    }
}

extension View {
    func wallabagPlusProtected() -> some View {
        modifier(WallabagPlusProtectedModifier())
    }
}
