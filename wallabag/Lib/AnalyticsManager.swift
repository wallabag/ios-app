//
//  AnalyticsManager.swift
//  wallabag
//
//  Created by maxime marinel on 12/03/2018.
//  Copyright © 2018 maxime marinel. All rights reserved.
//

import Crashlytics
import Fabric
import UIKit

protocol AnalyticsManagerProtocol {
    func sendScreenViewed(_ event: AnalyticsManager.AnalyticsViewEvent)
    func send(_ event: AnalyticsManager.AnalyticsEvent)
}

class AnalyticsManager: AnalyticsManagerProtocol {
    enum AnalyticsViewEvent {
        var name: String {
            return String(describing: self)
        }

        case articlesView
        case articleView
        case aboutView
        case homeView
        case clientIdView
        case loginView
        case serverView
        case settingView
        case themeChoiceView
        case tipView
        case voiceChoiseView
    }

    enum AnalyticsEvent {
        var category: String {
            switch self {
            case .synthesis, .shareArticle, .tip, .tipPurchased:
                return "User Interaction"
            }
        }

        var name: String {
            switch self {
            case .synthesis:
                return "Use Synthesis"
            case .shareArticle:
                return "Use share menu"
            case .tip:
                return "Tip button pressed"
            case .tipPurchased:
                return "Tip purchased"
            }
        }

        var label: String {
            switch self {
            case .shareArticle:
                return "Article view"
            default:
                return ""
            }
        }

        var value: NSNumber {
            switch self {
            case let .synthesis(state):
                return state ? 1 : 0
            case .shareArticle, .tip, .tipPurchased:
                return 1
            }
        }

        case synthesis(state: Bool)
        case shareArticle
        case tip
        case tipPurchased
    }

    func sendScreenViewed(_ event: AnalyticsViewEvent) {
        Answers.logContentView(withName: event.name, contentType: nil, contentId: nil, customAttributes: nil)
    }

    func send(_ event: AnalyticsEvent) {
        Answers.logCustomEvent(withName: event.category, customAttributes: [event.name: event.value])
    }
}
