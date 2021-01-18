import SwiftUI

@available(*, deprecated)
struct EntryPictoImage: View {
    @ObservedObject var entry: Entry
    var keyPath: KeyPath<Entry, Bool>
    var picto: String
    var body: some View {
        Image(systemName: entry[keyPath: keyPath] ? "\(picto).fill" : picto)
    }
}
