//
//  ArticleListView.swift
//  wallabag
//
//  Created by Marinel Maxime on 11/07/2019.
//

import CoreData
import SwiftUI

struct EntriesView: View {
    @ObservedObject var pasteBoardPublisher = PasteBoardPublisher()
    @EnvironmentObject var appSync: AppSync
    @EnvironmentObject var entryPublisher: EntryPublisher
    @Binding var showMenu: Bool
    @State private var showAddView: Bool = false
    @State private var filter: RetrieveMode = RetrieveMode(fromCase: WallabagUserDefaults.defaultMode)
    
    @FetchRequest(entity: Entry.entity(), sortDescriptors: []) var entries: FetchedResults<Entry>
    
    var body: some View {
        NavigationView {
            Group {
                // MARK: Pasteboard
                if pasteBoardPublisher.showPasteBoardView {
                    PasteBoardView().environmentObject(pasteBoardPublisher)
                }
                // MARK: Picker
                RetrieveModePicker(filter: self.$filter)
                
                EntriesListView(predicate: filter.predicate())

                // MARK: WORKAROUND 13.2 navigation back crash
                NavigationLink(destination: AddEntryView(), isActive: $showAddView, label: { Image(systemName: "plus") }).hidden()
            }
            .navigationBarTitle("Articles")
            .navigationBarItems(
                leading: Button(action: {
                    withAnimation {
                        self.showMenu.toggle()
                    }
                }, label: { Image(systemName: "list.bullet") }),
                trailing:
                HStack {
                    RefreshButton()
                    Button(action: { self.showAddView = true }, label: { Image(systemName: "plus").frame(width: 34, height: 34, alignment: .center) })
                }
            )
            // MARK: SplitView
            entryPublisher.entries.first.map { EntryView(entry: $0) }
        }
    }
}

#if DEBUG
struct ArticleListView_Previews: PreviewProvider {
    static var previews: some View {
        EntriesView(showMenu: .constant(false))
            .environmentObject(PasteBoardPublisher())
            .environmentObject(AppSync())
            .environmentObject(EntryPublisher())
    }
}
#endif
