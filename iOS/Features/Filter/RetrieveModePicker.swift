import SwiftUI

struct RetrieveModePicker: View {
    @Binding var filter: RetrieveMode

    var body: some View {
        Picker(selection: $filter, label: Text("Filter"), content: {
            Text(LocalizedStringKey(RetrieveMode.allArticles.rawValue)).tag(RetrieveMode.allArticles)
            Text(LocalizedStringKey(RetrieveMode.starredArticles.rawValue)).tag(RetrieveMode.starredArticles)
            Text(LocalizedStringKey(RetrieveMode.unarchivedArticles.rawValue)).tag(RetrieveMode.unarchivedArticles)
            Text(LocalizedStringKey(RetrieveMode.archivedArticles.rawValue)).tag(RetrieveMode.archivedArticles)
        }).pickerStyle(SegmentedPickerStyle())
    }
}

struct RetrieveModePicker_Previews: PreviewProvider {
    static var previews: some View {
        RetrieveModePicker(filter: .constant(.archivedArticles)).previewLayout(.fixed(width: 300, height: 70))
    }
}
