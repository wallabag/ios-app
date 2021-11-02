import SwiftUI

struct AddEntryView: View {
    @StateObject private var model = AddEntryModel()

    var body: some View {
        Form {
            TextField("Url", text: $model.url)
                .autocapitalization(.none)
                .disableAutocorrection(true)
            HStack {
                Button(model.submitting ? "Submitting..." : "Submit") {
                    model.addEntry()
                }.disabled(model.submitting)
            }.disabled(model.url.isEmpty)
            if model.succeeded {
                Text("Great! Entry was added")
            }
        }
    }
}

private class AddEntryModel: ObservableObject {
    @Injector var session: WallabagSession

    @Published var url: String = ""
    @Published var submitting: Bool = false
    @Published var succeeded: Bool = false

    func addEntry() {
        submitting = true
        session.addEntry(url: url) {
            DispatchQueue.main.async {
                self.url = ""
                self.submitting = false
                withAnimation {
                    self.succeeded = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                        self.succeeded = false
                    }
                }
            }
        }
    }
}

struct AddEntryView_Previews: PreviewProvider {
    static var previews: some View {
        AddEntryView()
    }
}
