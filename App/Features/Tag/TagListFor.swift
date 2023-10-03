import CoreData
import SwiftUI

struct TagListFor: View {
    @EnvironmentObject var appState: AppState
    @State private var tagLabel: String = ""

    @ObservedObject var tagsForEntry: TagsForEntryPublisher

    var body: some View {
        VStack(alignment: .leading) {
            Text("Tag").font(.largeTitle).bold().padding()
            HStack {
                TextField("New tag", text: $tagLabel)
                Button(action: {
                    tagsForEntry.add(tag: tagLabel)
                    tagLabel = ""
                }, label: { Text("Add") })
            }.padding(.horizontal)
            List(tagsForEntry.tags) { tag in
                TagRow(tag: tag, tagsForEntry: tagsForEntry)
            }
        }
    }
}

/*
 struct TagListFor_Previews: PreviewProvider {
 static var previews: some View {
     TagListFor(entry: Entry())
 }
 }*/
