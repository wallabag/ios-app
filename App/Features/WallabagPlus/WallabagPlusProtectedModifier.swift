import RevenueCat
import RevenueCatUI
import SwiftUI

struct WallabagPlusProtectedModifier: ViewModifier {
    @Environment(WallabagPlusStore.self) private var wallabagPlusStore

    func body(content: Content) -> some View {
        VStack {
            if wallabagPlusStore.proUnlocked {
                content
            } else {
                VStack {
                    Image("logo")
                        .resizable()
                        .scaledToFit()
                    Text("Sorry, this feature require you subscribe to wallabag Plus")
                        .fontDesign(.rounded)
                }
                .presentPaywallIfNeeded(requiredEntitlementIdentifier: "pro")
            }
        }
    }
}

extension View {
    func wallabagPlusProtected() -> some View {
        modifier(WallabagPlusProtectedModifier())
    }
}
