import CoreData
import SwiftUI

struct DeleteEntryButton: View {
    @Binding var showConfirm: Bool
    var showText: Bool = true
    var body: some View {
        Button(action: {
            showConfirm = true
        }, label: {
            if showText {
                Text("Delete")
            }
            Image(systemName: "trash")
        })
    }
}
