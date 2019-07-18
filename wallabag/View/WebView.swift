//
//  WebView.swift
//  wallabag
//
//  Created by Marinel Maxime on 18/07/2019.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    var entry: Entry!

    func makeUIView(context _: Context) -> WKWebView {
        WKWebView(frame: .zero)
    }

    func updateUIView(_ view: WKWebView, context _: Context) {
        view.load(entry: entry, withTheme: "white", justify: false)
    }
}

#if DEBUG
    struct WebView_Previews: PreviewProvider {
        static var previews: some View {
            Text("No preview")
        }
    }
#endif
