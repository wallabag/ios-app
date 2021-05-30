import SwiftUI

struct RegistrationView: View {
    var body: some View {
        NavigationView {
            VStack {
                Image("logo")
                    .resizable()
                    .scaledToFit()
                Text("Wallabag").font(.title)
                NavigationLink("Log in", destination: ServerView())
            }.navigationBarHidden(true)
        }.navigationViewStyle(StackNavigationViewStyle())
        #warning("Fix navigation style")
    }
}

#if DEBUG
    struct RegistrationView_Previews: PreviewProvider {
        static var previews: some View {
            RegistrationView()
        }
    }
#endif
