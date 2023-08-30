import Foundation
import SharedLib
import SwiftUI

struct SearchView: View {
    @ObservedObject var searchViewModel: SearchViewModel
    @State private var showSearchBar: Bool = false {
        willSet {
            if newValue == false {
                searchViewModel.search = ""
            }
        }
    }

    var body: some View {
        VStack {
            HStack {
                if showSearchBar {
                    TextField("Search", text: $searchViewModel.search)
                        .textFieldStyle(.roundedBorder)
                        .disableAutocorrection(true)
                    #if os(iOS)
                        .autocapitalization(.none)
                    #endif
                        .padding(.leading)
                } else {
                    RetrieveModePicker(filter: $searchViewModel.retrieveMode)
                }
                Button(action: {
                    withAnimation {
                        showSearchBar = !showSearchBar
                    }
                }, label: {
                    Image(systemName: showSearchBar ? "list.bullet.below.rectangle" : "magnifyingglass")
                        .padding(.trailing)
                })
                .buttonStyle(.plain)
            }
        }
    }
}
