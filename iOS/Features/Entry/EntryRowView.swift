import Factory
import HTMLEntities
import SharedLib
import SwiftUI

struct EntryRowView: View {
    @ObservedObject var entry: Entry
    @EnvironmentObject var appState: AppState
    @AppStorage("readingSpeed") var readingSpeed: Double = 200

    var body: some View {
        HStack {
            if WallabagUserDefaults.showImageInList {
                EntryPicture(url: entry.previewPicture).frame(width: 50, height: 50, alignment: .center)
            }
            VStack(alignment: .leading) {
                Text(entry.title?.htmlUnescape() ?? "")
                    .font(.headline)
                Text("Reading time \(readingTime())")
                    .font(.footnote)
                HStack {
                    EntryPictoImage(entry: entry, keyPath: \.isArchived, picto: "book")
                    EntryPictoImage(entry: entry, keyPath: \.isStarred, picto: "star")
                    Text(entry.domainName ?? "")
                        .font(.footnote)
                    Spacer()
                }
            }
        }
    }

    private func readingTime() -> String {
        let readingTime = Double(entry.readingTime) / readingSpeed * 200.0
        return readingTime.readingTime
    }
}

struct ArticleRowView_Previews: PreviewProvider {
    static var entry: Entry {
        let coreData = Container.shared.coreData()
        let entry = Entry(context: coreData.viewContext)
        entry.title = "Marc Zuckerberg devrait être passible d'une peine de prison pour mensonges répétés au sujet de la protection de la vie privée des utilisateurs Facebook, d'après le sénateur américain Ron Wyden"

        return entry
    }

    static var previews: some View {
        EntryRowView(entry: entry).previewLayout(.fixed(width: 300, height: 70))
    }
}
