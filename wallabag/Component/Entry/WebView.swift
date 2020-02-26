//
//  WebView.swift
//  wallabag
//
//  Created by Marinel Maxime on 18/07/2019.
//

import CoreData
import SafariServices
import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    var entry: Entry

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, WKNavigationDelegate, UIScrollViewDelegate {
        var webView: WebView
        @CoreDataViewContext var context: NSManagedObjectContext

        init(_ webView: WebView) {
            self.webView = webView
        }

        func webView(_ webView: WKWebView, didFinish _: WKNavigation!) {
            webView.scrollView.setContentOffset(CGPoint(x: 0.0, y: self.webView.entry.screenPositionForWebView), animated: true)
        }

        func webView(_: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            guard let urlTarget = navigationAction.request.url else {
                decisionHandler(.cancel)
                return
            }
            let urlAbsolute = urlTarget.absoluteString

            if urlAbsolute.hasPrefix(Bundle.main.bundleURL.absoluteString) || urlAbsolute == "about:blank" {
                decisionHandler(.allow)
                return
            }

            let safariController = SFSafariViewController(url: urlTarget)
            safariController.modalPresentationStyle = .overFullScreen

            UIApplication.shared.open(urlTarget, options: [:], completionHandler: nil)
            decisionHandler(.cancel)
        }

        func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
            context.perform {
                self.webView.entry.screenPosition = Float(scrollView.contentOffset.y)
                try? self.context.save()
            }
        }
    }

    func makeUIView(context: Context) -> WKWebView {
        let webview = WKWebView(frame: .zero)
        webview.navigationDelegate = context.coordinator
        webview.scrollView.delegate = context.coordinator
        return webview
    }

    func updateUIView(_ view: WKWebView, context _: Context) {
        view.load(entry: entry, justify: false)
    }
}

#if DEBUG
    struct WebView_Previews: PreviewProvider {
        static var entry: Entry = {
            let entry = Entry()
            entry.title = "Test"
            entry.content = "<p>Nice Content</p>"
            return entry
        }()

        static var previews: some View {
            Group {
                WebView(entry: entry).colorScheme(.light)
                WebView(entry: entry).colorScheme(.dark)
            }
        }
    }
#endif
