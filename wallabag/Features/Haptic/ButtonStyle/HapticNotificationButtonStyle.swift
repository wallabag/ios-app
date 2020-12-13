import SwiftUI

struct HapticNotificationButtonStyle: ButtonStyle {
    let feedbackType: UINotificationFeedbackGenerator.FeedbackType
    func makeBody(configuration: Configuration) -> some View {
        if configuration.isPressed {
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(feedbackType)
        }
        return configuration.label
    }
}
