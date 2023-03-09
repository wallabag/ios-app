import SwiftUI

struct AboutView: View {
    @BundleKey("CFBundleShortVersionString")
    var version: String

    @BundleKey("CFBundleVersion")
    var build: String

    var body: some View {
        VStack {
            Text("Wallabag").font(.largeTitle).fontWeight(.bold)
            Text(String(format: "Version %@ build %@".localized, arguments: [version, build]))
            Spacer()
            Link("Project page", destination: "https://github.com/wallabag/ios-app")
            Spacer()
            Text("Made by Maxime Marinel @bourvill")
        }
        .navigationTitle("About")
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
