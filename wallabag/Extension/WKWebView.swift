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
    func load(entry: Entry, withTheme theme: String, justify: Bool) {
        DispatchQueue.main.async { [weak self] in
            guard let content = self?.contentForWebView(entry, withTheme: theme, justify: justify) else { return }
            self?.loadHTMLString(content, baseURL: Bundle.main.bundleURL)
        }
    }

    func contentForWebView(_ entry: Entry, withTheme theme: String, justify: Bool) -> String? {
        do {
            guard let content = entry.content, let title = entry.title else { return nil }
            let html = try String(contentsOfFile: Bundle.main.path(forResource: "article", ofType: "html")!)
            let justify = justify ? "justify.css" : ""

            return String(format: html, arguments: [justify, theme, title, content])
        } catch {
            fatalError("Unable to load article view")
        }
    }
}
