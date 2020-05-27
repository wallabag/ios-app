//
//  WebView.swift
//  wallabag
//
//  Created by Marinel Maxime on 18/07/2019.
//

import Combine
import CoreData
import SafariServices
import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    var entry: Entry
    private(set) var wkWebView = WKWebView(frame: .zero)
    @Binding var size: Double

    func makeCoordinator() -> Coordinator {
        Coordinator(self, size: $size)
    }

    class Coordinator: NSObject, WKNavigationDelegate, UIScrollViewDelegate {
        @CoreDataViewContext var context: NSManagedObjectContext
        @Binding var size: Double

        private var webView: WebView
        private var cancellable: AnyCancellable?

        init(_ webView: WebView, size: Binding<Double>) {
            self.webView = webView
            _size = size
            super.init()

            cancellable = NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)
                .sink(receiveValue: webViewToLastPosition)
        }

        func webViewToLastPosition(_: Notification?) {
            DispatchQueue.main.async {
                self.webView.wkWebView.scrollView.setContentOffset(CGPoint(x: 0.0, y: self.webView.entry.screenPositionForWebView), animated: true)
            }
        }

        func webView(_ webView: WKWebView, didFinish _: WKNavigation!) {
            webViewToLastPosition(nil)
            let js = "document.getElementsByTagName('body')[0].style.fontSize='\(self.webView.size)%'"
            webView.evaluateJavaScript(js, completionHandler: nil)
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

            if navigationAction.targetFrame?.isMainFrame == false {
                decisionHandler(.allow)
                return
            }

            let safariController = SFSafariViewController(url: urlTarget)
            safariController.modalPresentationStyle = .overFullScreen

            UIApplication.shared.open(urlTarget, options: [:], completionHandler: nil)
            decisionHandler(.cancel)
        }

        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            context.perform {
                self.webView.entry.screenPosition = Float(scrollView.contentOffset.y)
                try? self.context.save()
            }
        }
    }

    func makeUIView(context: Context) -> WKWebView {
        wkWebView.navigationDelegate = context.coordinator
        wkWebView.scrollView.delegate = context.coordinator
        wkWebView.load(entry: entry, justify: false)

        return wkWebView
    }

    func updateUIView(_ webView: WKWebView, context _: Context) {
        let js = "document.getElementsByTagName('body')[0].style.fontSize='\(self.size)%'"
        webView.evaluateJavaScript(js, completionHandler: nil)
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
                WebView(entry: entry, size: .constant(100)).colorScheme(.light)
                WebView(entry: entry, size: .constant(100)).colorScheme(.dark)
            }
        }
    }
#endif
