import SwiftUI

struct RegistrationView: View {
    @StateObject var model = RegistrationModel()
    var body: some View {
        VStack(alignment: .leading) {
            Text("Account").font(.title).fontWeight(.black)
            TextField("Instance", text: $model.host)
            TextField("Login", text: $model.login)
            TextField("password", text: $model.password)
            TextField("Client id", text: $model.clientId)
            TextField("Client secret", text: $model.clientSecret)
            Button("Submit") {}
        }
        .padding()
        Spacer()
    }
}

final class RegistrationModel: ObservableObject {
    @Published var host: String = ""
    @Published var clientId: String = ""
    @Published var clientSecret: String = ""
    @Published var login: String = ""
    @Published var password: String = ""

    init() {
        host = WallabagUserDefaults.host
        clientId = WallabagUserDefaults.clientId
        clientSecret = WallabagUserDefaults.clientSecret
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}
