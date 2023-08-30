import SwiftUI

extension View {
    func addSwipeToBack(action: @escaping () -> Void) -> some View {
        gesture(
            DragGesture()
                .onEnded { gesture in
                    if gesture.startLocation.x < 50, gesture.translation.width > 80 {
                        action()
                    }
                }
        )
    }
}
