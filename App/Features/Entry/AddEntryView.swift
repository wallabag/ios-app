import Factory
import SwiftUI

struct AddEntryView: View {
    @StateObject private var model = AddEntryModel()

    var body: some View {
        Form {
            TextField("Url", text: $model.url)
            #if os(iOS)
                .autocapitalization(.none)
            #endif
                .disableAutocorrection(true)
            HStack {
                Button(model.submitting ? "Submitting..." : "Submit") {
                    Task {
                        await model.addEntry()
                    }
                }.disabled(model.submitting)
            }.disabled(model.url.isEmpty)
            if model.succeeded {
                Text("Great! Entry was added")
            }
        }
        .navigationTitle("Add entry")
    }
}

private class AddEntryModel: ObservableObject {
    @Injected(\.wallabagSession) private var session

    @Published var url: String = ""
    @Published var submitting: Bool = false
    @Published var succeeded: Bool = false

    @MainActor
    func addEntry() async {
        submitting = true
        try? await session.addEntry(url: url)
        url = ""
        submitting = false
        withAnimation {
            self.succeeded = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                self.succeeded = false
            }
        }
    }
}

struct AddEntryView_Previews: PreviewProvider {
    static var previews: some View {
        AddEntryView()
    }
}
