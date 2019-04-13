//
//  File.swift
//  wallabagTests
//
//  Created by maxime marinel on 13/04/2019.
//

import Foundation
@testable import wallabag

class AnalyticsManagerMock: AnalyticsManagerProtocol {
    var sendScreenViewedCalled = false
    var sendCalled = false
    var eventScreenView: AnalyticsManager.AnalyticsViewEvent?
    var event: AnalyticsManager.AnalyticsEvent?
    func sendScreenViewed(_ event: AnalyticsManager.AnalyticsViewEvent) {
        sendScreenViewedCalled = true
        self.eventScreenView = event
    }
    func send(_ event: AnalyticsManager.AnalyticsEvent) {
        sendCalled = true
        self.event = event
    }
}
