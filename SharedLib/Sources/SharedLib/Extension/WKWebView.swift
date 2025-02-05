import Foundation
import WebKit

public extension WKWebView {
    func load(content: String?, justify: Bool) {
        guard let content = contentForWebView(content, justify: justify) else { return }
        loadHTMLString(content, baseURL: Bundle.main.bundleURL)
    }

    nonisolated func contentForWebView(_ content: String?, justify: Bool) -> String? {
        do {
            guard let content else { return nil }
            let html = try String(contentsOfFile: Bundle.main.path(forResource: "article", ofType: "html")!)
            let justify = justify ? "justify.css" : ""

            return String(format: html, arguments: [justify, content])
        } catch {
            fatalError("Unable to load article view")
        }
    }

    func fontSizePercent(_ fontSize: Double) {
        let javascript = "document.getElementsByTagName('body')[0].style.fontSize='\(fontSize)%'"
        evaluateJavaScript(javascript, completionHandler: nil)
    }
}
