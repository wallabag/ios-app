import Factory
import SwiftUI

final class TagSuggestionViewModel: ObservableObject {
    @Injected(\.chatAssistant) private var chatAssistant
    @Published var suggestions: [String] = []
    @Published var isLoading = false

    @MainActor
    func generateSynthesis(from entry: Entry) async throws {
        defer {
            isLoading = false
        }
        isLoading = true

        guard let content = entry.content?.withoutHTML else { return }

        suggestions = try await chatAssistant.generateTags(content: content)
    }
}

struct TagSuggestionView: View {
    @StateObject private var viewModel = TagSuggestionViewModel()
    @State private var selection = Set<String>()

    let entry: Entry

    var body: some View {
        VStack {
            if viewModel.isLoading {
                Text("Your assistant is working")
                ProgressView()
            } else {
                List {
                    ForEach(viewModel.suggestions, id: \.self) { suggestion in
                        Button(action: {
                            if selection.contains(suggestion) {
                                selection.remove(suggestion)
                            } else {
                                selection.insert(suggestion)
                            }
                        }, label: {
                            HStack {
                                Text(suggestion)
                                    .padding()
                                    .fontDesign(.serif)
                                Spacer()
                                if selection.contains(suggestion) {
                                    Image(systemName: "checkmark.circle.fill")
                                } else {
                                    Image(systemName: "circle")
                                }
                            }
                        })
                    }
                }
                .listStyle(.plain)
                if !selection.isEmpty {
                    Button(action: {}, label: {
                        Text("Add \(selection.count.formatted()) tags")
                    })
                }
            }
        }
        .navigationTitle("Tag suggestion")
        .task {
            do {
                try await viewModel.generateSynthesis(from: entry)
            } catch {
                print(error)
            }
        }
    }
}

// #Preview {
//    SynthesisEntryView(entry: .)
// }
