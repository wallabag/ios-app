//
//  HapticNotificationButtonStyle.swift
//  wallabag
//
//  Created by Marinel Maxime on 19/05/2020.
//

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
