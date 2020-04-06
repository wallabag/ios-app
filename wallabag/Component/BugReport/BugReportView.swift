//
//  BugReportView.swift
//  wallabag
//
//  Created by Marinel Maxime on 28/03/2020.
//

import SwiftUI

struct BugReportView: View {
    var body: some View {
        VStack {
            Text("""
            Wallabag is an open source project.
            You can help this project and this application to be a better application.

            Open source is not just writing the code, but a state of mind in which everyone can use their means to advance the application.

            Reporting a bug is a big help! But you can also just suggest improvements for example.
            """)
            Spacer()
            Button(action: {
                UIApplication.shared.open("https://github.com/wallabag/ios-app/issues")
            }, label: {
                Text("Report issue")
            })
        }
    }
}

struct BugReportView_Previews: PreviewProvider {
    static var previews: some View {
        BugReportView()
    }
}
