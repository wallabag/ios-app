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
                    .buttonBorderShape(.capsule)
            }.navigationBarHidden(true)
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
