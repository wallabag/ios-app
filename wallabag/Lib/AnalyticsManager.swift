//
//  AnalyticsManager.swift
//  wallabag
//
//  Created by maxime marinel on 12/03/2018.
//  Copyright © 2018 maxime marinel. All rights reserved.
//

import UIKit

class AnalyticsManager {
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
            case .synthesis(_), .shareArticle:
                return "User Interaction"
            }
        }
        var action: String {
            switch self {
            case .synthesis(_):
                return "Use Synthesis"
            case .shareArticle:
                return "Use share menu"
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
            case .synthesis(let state):
                return state ? 1 : 0
            case .shareArticle:
                return 1
            }
        }

        case synthesis(state: Bool)
        case shareArticle
    }

    lazy var tracker: GAITracker = {
        guard let gai = GAI.sharedInstance() else {
            assert(false, "Google Analytics not configured correctly")
        }
        return gai.defaultTracker
    }()
    
    func sendScreenViewed(_ event: AnalyticsViewEvent) {
        tracker.set(kGAIScreenName, value: event.name)
        guard let builder = GAIDictionaryBuilder.createScreenView(),
            let build = builder.build() as [NSObject: AnyObject]? else { return }
        tracker.send(build)
    }

    func send(_ event: AnalyticsEvent) {
        guard let builder = GAIDictionaryBuilder.createEvent(withCategory: event.category, action: event.action, label: event.label, value: event.value),
            let build = builder.build() as [NSObject: AnyObject]? else { return }
        tracker.send(build)
    }
}
