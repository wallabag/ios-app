//
//  UIWebView.swift
//  wallabag
//
//  Created by maxime marinel on 11/06/2018.
//  Copyright © 2018 maxime marinel. All rights reserved.
//

import Foundation
import UIKit
import WebKit

extension WKWebView {
    func load(entry: Entry, justify: Bool) {
        DispatchQueue.main.async { [weak self] in
            guard let content = self?.contentForWebView(entry, justify: justify) else { return }
            self?.loadHTMLString(content, baseURL: Bundle.main.bundleURL)
        }
    }

    func contentForWebView(_ entry: Entry, justify: Bool) -> String? {
        do {
            guard let content = entry.content else { return nil }
            let html = try String(contentsOfFile: Bundle.main.path(forResource: "article", ofType: "html")!)
            let justify = justify ? "justify.css" : ""

            return String(format: html, arguments: [justify, content])
        } catch {
            fatalError("Unable to load article view")
        }
    }
}
