//
//  PasteBoardView.swift
//  wallabag
//
//  Created by Marinel Maxime on 24/11/2019.
//

import SwiftUI

struct PasteBoardView: View {
    @EnvironmentObject var pasteBoardPublisher: PasteBoardPublisher

    var body: some View {
        HStack(alignment: .center) {
            Image(systemName: "doc.on.clipboard")
            VStack {
                Text("New url in pasteboard detected")
                    .font(.headline)
                Text(pasteBoardPublisher.pasteBoardUrl)
                    .lineLimit(1)
                HStack {
                    Button(action: {
                        self.pasteBoardPublisher.addUrl()
                    }, label: {
                        Text("Add")
                    })
                    Button(action: {
                        self.pasteBoardPublisher.hide()
                    }, label: {
                        Text("Cancel")
                    })
                }
            }
        }
    }
}

struct PasteBoardView_Previews: PreviewProvider {
    static var publisher: PasteBoardPublisher = {
        let pub = PasteBoardPublisher()
        pub.pasteBoardUrl = "http://wallabag-with-a-long-url.org"
        return pub
    }()

    static var previews: some View {
        Group {
            PasteBoardView().previewLayout(.sizeThatFits).environmentObject(publisher)
            PasteBoardView().previewLayout(.fixed(width: 250, height: 60)).environmentObject(publisher)
        }
    }
}
