//
//  SearchView.swift
//  wallabag
//
//  Created by Marinel Maxime on 14/05/2020.
//

import Foundation
import SwiftUI

struct SearchView: View {
    @ObservedObject var searchPublisher: SearchPublisher
    @State private var showSearchBar: Bool = false {
        willSet {
            if newValue == false {
                searchPublisher.search = ""
            }
        }
    }

    var body: some View {
        VStack {
            HStack {
                if showSearchBar {
                    TextField("Search", text: $searchPublisher.search)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                        .padding(.leading)
                } else {
                    RetrieveModePicker(filter: $searchPublisher.retrieveMode)
                }
                Button(action: {
                    withAnimation {
                        self.showSearchBar = !self.showSearchBar
                    }
                }, label: {
                    Image(systemName: "magnifyingglass").padding(.trailing)
                })
            }
        }
    }
}
