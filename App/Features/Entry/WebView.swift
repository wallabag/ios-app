import CoreData
import SafariServices
import SwiftUI
import WebKit

#if os(iOS)
    struct WebView: UIViewRepresentable {
        var entry: Entry
        private(set) var wkWebView = WKWebView(frame: .zero)
        @EnvironmentObject var appSetting: AppSetting
        @Binding var progress: Double

        func makeCoordinator() -> Coordinator {
            Coordinator(self, appSetting: appSetting)
        }

        class Coordinator: NSObject, WKNavigationDelegate, UIScrollViewDelegate {
            @CoreDataViewContext var context: NSManagedObjectContext
            var appSetting: AppSetting

            private var webView: WebView

            init(_ webView: WebView, appSetting: AppSetting) {
                self.webView = webView
                self.appSetting = appSetting
                super.init()
            }

            func webViewToLastPosition() {
                webView.wkWebView.scrollView.setContentOffset(
                    CGPoint(
                        x: 0.0,
                        y: webView.entry.screenPositionForWebView
                    ),
                    animated: true
                )
            }

            func webView(_ webView: WKWebView, didFinish _: WKNavigation!) {
                webViewToLastPosition()
                webView.fontSizePercent(appSetting.webFontSizePercent)
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

            func scrollViewDidScroll(_ scrollView: UIScrollView) {
                webView.progress = scrollView.contentOffset.y / (scrollView.contentSize.height - scrollView.bounds.height)
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
            wkWebView.load(content: entry.content, justify: UserDefaults.standard.bool(forKey: "justifyArticle"))

            return wkWebView
        }

        func updateUIView(_ webView: WKWebView, context _: Context) {
            webView.fontSizePercent(appSetting.webFontSizePercent)
        }
    }
#endif

#if os(macOS)
    struct WebView: NSViewRepresentable {
        var entry: Entry
        private(set) var wkWebView = WKWebView(frame: .zero)
        @EnvironmentObject var appSetting: AppSetting

        func makeNSView(context _: Context) -> WKWebView {
            wkWebView.load(content: entry.content, justify: false)

            return wkWebView
        }

        func updateNSView(_ nsView: WKWebView, context _: Context) {
            nsView.load(content: entry.content, justify: false)
            nsView.fontSizePercent(appSetting.webFontSizePercent)
        }

        func makeCoordinator() -> Coordinator {
            Coordinator(self, appSetting: appSetting)
        }

        class Coordinator: NSObject, WKNavigationDelegate {
            @CoreDataViewContext var context: NSManagedObjectContext
            var appSetting: AppSetting

            private var webView: WebView

            init(_ webView: WebView, appSetting: AppSetting) {
                self.webView = webView
                self.appSetting = appSetting
                super.init()
            }

            func webViewToLastPosition() {
                /*    DispatchQueue.main.async {
                     self.webView.wkWebView.scrollView.setContentOffset(CGPoint(x: 0.0, y: self.webView.entry.screenPositionForWebView), animated: true)
                 }*/
            }

            func webView(_ webView: WKWebView, didFinish _: WKNavigation!) {
                webViewToLastPosition()
                webView.fontSizePercent(appSetting.webFontSizePercent)
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

                /* let safariController = SFSafariViewController(url: urlTarget)
                 safariController.modalPresentationStyle = .overFullScreen

                 UIApplication.shared.open(urlTarget, options: [:], completionHandler: nil)
                 */
                decisionHandler(.cancel)
            }

            /*
             func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
             context.perform {
             self.webView.entry.screenPosition = Float(scrollView.contentOffset.y)
             try? self.context.save()
             }
             }*/
        }
    }

#endif

struct WebView_Previews: PreviewProvider {
    static var entry: Entry = {
        let entry = Entry()
        entry.title = "Test"
        entry.content = "<p>Nice Content</p>"
        return entry
    }()

    static var previews: some View {
        Group {
            WebView(
                entry: entry, progress: .constant(0.5)
            ).colorScheme(.light)
            WebView(
                entry: entry, progress: .constant(0.5)
            ).colorScheme(.dark)
        }
    }
}
