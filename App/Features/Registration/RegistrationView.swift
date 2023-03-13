import SwiftUI

struct RegistrationView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Image("logo")
                    .resizable()
                    .scaledToFit()
                Text("Wallabag")
                    .font(.title)
                NavigationLink("Log in", destination: ServerView())
                    .buttonStyle(.borderedProminent)
            }
            #if os(iOS)
            .navigationBarHidden(true)
            #endif
        }
    }
}

#if DEBUG
    struct RegistrationView_Previews: PreviewProvider {
        static var previews: some View {
            RegistrationView()
        }
    }
#endif
