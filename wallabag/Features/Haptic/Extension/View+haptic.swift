//
//  View.swift
//  wallabag
//
//  Created by Marinel Maxime on 19/05/2020.
//

import SwiftUI

extension View {
    func hapticNotification(_ feedbackType: UINotificationFeedbackGenerator.FeedbackType) -> some View {
        buttonStyle(HapticNotificationButtonStyle(feedbackType: feedbackType))
    }
}
