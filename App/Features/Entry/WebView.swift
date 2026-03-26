import CoreData
import SafariServices
import SwiftUI
import WebKit

#if os(iOS)
    struct WebView: UIViewRepresentable {
        var entry: Entry
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

            func webViewToLastPosition(in webView: WKWebView) {
                let position = self.webView.entry.screenPositionForWebView
                if position > 0 {
                    // Check if content is actually loaded by verifying contentSize
                    if webView.scrollView.contentSize.height > webView.bounds.height {
                        webView.scrollView.setContentOffset(
                            CGPoint(x: 0.0, y: position),
                            animated: true
                        )
                    } else {
                        // Content not ready yet, try again after a minimal delay
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                            self.webViewToLastPosition(in: webView)
                        }
                    }
                }
            }

            func webView(_ webView: WKWebView, didFinish _: WKNavigation!) {
                webView.fontSizePercent(appSetting.webFontSizePercent)
                self.webViewToLastPosition(in: webView)
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
                let scrollableHeight = scrollView.contentSize.height - scrollView.bounds.height
                if scrollableHeight > 0 {
                    webView.progress = scrollView.contentOffset.y / scrollableHeight
                } else {
                    webView.progress = 0
                }
            }

            func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
                context.perform {
                    self.webView.entry.screenPosition = Float(scrollView.contentOffset.y)
                    try? self.context.save()
                }
            }
        }

        func makeUIView(context: Context) -> WKWebView {
            let webView = WKWebView(frame: .zero)
            webView.navigationDelegate = context.coordinator
            webView.scrollView.delegate = context.coordinator
            webView.isOpaque = false
            webView.backgroundColor = .clear
            webView.scrollView.backgroundColor = .clear
            webView.scrollView.contentInsetAdjustmentBehavior = .always
            
            webView.load(content: entry.titleHtml + (entry.content ?? ""), justify: UserDefaults.standard.bool(forKey: "justifyArticle"))

            return webView
        }

        func updateUIView(_ webView: WKWebView, context _: Context) {
            webView.fontSizePercent(appSetting.webFontSizePercent)
        }
    }
#endif

#if os(macOS)
    struct WebView: NSViewRepresentable {
        var entry: Entry
        @EnvironmentObject var appSetting: AppSetting
        @Binding var progress: Double

        func makeNSView(context: Context) -> WKWebView {
            let webView = WKWebView(frame: .zero)
            webView.navigationDelegate = context.coordinator
            webView.load(content: entry.titleHtml + (entry.content ?? ""), justify: false)

            return webView
        }

        func updateNSView(_ nsView: WKWebView, context _: Context) {
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
            ).environmentObject(AppSetting())
            .colorScheme(.light)
            WebView(
                entry: entry, progress: .constant(0.5)
            ).environmentObject(AppSetting())
            .colorScheme(.dark)
        }
    }
}
