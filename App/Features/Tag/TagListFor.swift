import CoreData
import SwiftUI

struct TagListFor: View {
    @EnvironmentObject var appState: AppState
    @State private var tagLabel: String = ""
    @ObservedObject var entry: Entry

    @State var viewModel = TagsForEntryViewModel()

    var body: some View {
        NavigationStack {
            Form {
                Section("New tag") {
                    TextField("Tag name", text: $tagLabel)
                    Button(action: {
                        Task {
                            await viewModel.add(tag: tagLabel, for: entry)
                            tagLabel = ""
                        }
                    }, label: {
                        if viewModel.isLoading {
                            ProgressView()
                        } else {
                            Text("Add")
                        }
                    })
                    .disabled(viewModel.isLoading)
                }
                Section("Tags list") {
                    List(viewModel.tags) { tag in
                        Button(action: {
                            Task {
                                await viewModel.toggle(tag: tag, for: entry)
                            }
                        }, label: {
                            HStack {
                                Text(tag.label)
                                Spacer()
                                if viewModel.isLoading {
                                    ProgressView()
                                } else {
                                    Image(systemName: tag.isChecked ? "checkmark.circle" : "circle")
                                }
                            }
                            .contentShape(Rectangle())
                        })
                        .buttonStyle(.plain)
                        .disabled(viewModel.isLoading)
                    }
                }
            }
            .task {
                await viewModel.load(for: entry)
            }
            .navigationTitle("Tag")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

/*
 struct TagListFor_Previews: PreviewProvider {
 static var previews: some View {
     TagListFor(entry: Entry())
 }
 }*/
