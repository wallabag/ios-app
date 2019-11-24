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
        HStack(alignment: .top) {
            Image(systemName: "doc.on.clipboard")
            VStack {
                Text("New url in pasteboard detected")
                Text(pasteBoardPublisher.pasteBoardUrl)
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
    static var previews: some View {
        PasteBoardView()
    }
}
