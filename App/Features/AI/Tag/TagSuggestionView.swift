import Factory
import SwiftUI

struct TagSuggestionView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = TagSuggestionViewModel()

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
                            if viewModel.tagSelections.contains(suggestion) {
                                viewModel.tagSelections.remove(suggestion)
                            } else {
                                viewModel.tagSelections.insert(suggestion)
                            }
                        }, label: {
                            HStack {
                                Text(suggestion)
                                    .padding()
                                    .fontDesign(.serif)
                                Spacer()
                                if viewModel.tagSelections.contains(suggestion) {
                                    Image(systemName: "checkmark.circle.fill")
                                } else {
                                    Image(systemName: "circle")
                                }
                            }
                        })
                    }
                }
                .listStyle(.plain)
                if !viewModel.tagSelections.isEmpty {
                    Button(action: {
                        Task {
                            try? await viewModel.addTags(to: entry)
                            dismiss()
                        }
                    }, label: {
                        if viewModel.addingTags {
                            ProgressView()
                        } else {
                            Text("Add \(viewModel.tagSelections.count.formatted()) tags")
                        }
                    })
                    .buttonStyle(.borderedProminent)
                    .disabled(viewModel.addingTags)
                }
            }
        }
        .navigationTitle("Tag suggestion")
        .task {
            do {
                try await viewModel.generateTags(from: entry)
            } catch {
                print(error)
            }
        }
    }
}

// #Preview {
//    SynthesisEntryView(entry: .)
// }
