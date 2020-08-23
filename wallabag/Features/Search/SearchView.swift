//
//  SearchView.swift
//  wallabag
//
//  Created by Marinel Maxime on 14/05/2020.
//

import Foundation
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
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                        .padding(.leading)
                } else {
                    RetrieveModePicker(filter: $searchViewModel.retrieveMode)
                }
                Button(action: {
                    withAnimation {
                        self.showSearchBar = !self.showSearchBar
                    }
                }, label: {
                    Image(systemName: self.showSearchBar ? "list.bullet.below.rectangle" : "magnifyingglass")
                        .padding(.trailing)
                })
            }
        }
    }
}
