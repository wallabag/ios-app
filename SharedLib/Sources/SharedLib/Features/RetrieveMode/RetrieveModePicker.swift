import SwiftUI

public struct RetrieveModePicker: View {
    @Binding var filter: RetrieveMode

    public init(filter: Binding<RetrieveMode>) {
        _filter = filter
    }

    public var body: some View {
        Picker(selection: $filter, label: Text("Filter"), content: {
            Text(LocalizedStringKey(RetrieveMode.allArticles.rawValue)).tag(RetrieveMode.allArticles)
            Text(LocalizedStringKey(RetrieveMode.starredArticles.rawValue)).tag(RetrieveMode.starredArticles)
            Text(LocalizedStringKey(RetrieveMode.unarchivedArticles.rawValue)).tag(RetrieveMode.unarchivedArticles)
            Text(LocalizedStringKey(RetrieveMode.archivedArticles.rawValue)).tag(RetrieveMode.archivedArticles)
        })
        .pickerStyle(.segmented)
        .labelsHidden()
    }
}

struct RetrieveModePicker_Previews: PreviewProvider {
    static var previews: some View {
        RetrieveModePicker(filter: .constant(.archivedArticles)).previewLayout(.fixed(width: 300, height: 70))
    }
}
