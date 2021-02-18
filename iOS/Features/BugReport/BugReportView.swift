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
            Link("Report issue", destination: "https://github.com/wallabag/ios-app/issues")
        }
    }
}

struct BugReportView_Previews: PreviewProvider {
    static var previews: some View {
        BugReportView()
    }
}
