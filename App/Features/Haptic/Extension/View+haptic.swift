import SwiftUI

#if os(iOS)
    extension View {
        func hapticNotification(_ feedbackType: UINotificationFeedbackGenerator.FeedbackType) -> some View {
            buttonStyle(HapticNotificationButtonStyle(feedbackType: feedbackType))
        }
    }
#endif
