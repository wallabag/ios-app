//
//  UIWebView.swift
//  wallabag
//
//  Created by maxime marinel on 11/06/2018.
//  Copyright © 2018 maxime marinel. All rights reserved.
//

import Foundation
import UIKit
import WallabagCommon
import WebKit

extension WKWebView {
    func load(entry: Entry) {
        DispatchQueue.main.async { [weak self] in
            guard let content = self?.contentForWebView(entry) else { return }
            self?.loadHTMLString(content, baseURL: Bundle.main.bundleURL)
        }
    }

    func contentForWebView(_ entry: Entry) -> String? {
        let setting = WallabagSetting()
        do {
            guard let content = entry.content, let title = entry.title else { return nil }
            let html = try String(contentsOfFile: Bundle.main.path(forResource: "article", ofType: "html")!)
            let justify = setting.get(for: .justifyArticle) ? "justify.css" : ""

            return String(format: html, arguments: [justify, setting.get(for: .theme), title, content])
        } catch {
            fatalError("Unable to load article view")
        }
    }
}
