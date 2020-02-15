//
//  ErrorView.swift
//  wallabag
//
//  Created by Marinel Maxime on 15/02/2020.
//

import SwiftUI

struct ErrorView: View {
    @EnvironmentObject var errorPublisher: ErrorPublisher
    var body: some View {
        errorPublisher.lastError.map {
            Text($0.localizedDescription)
                .foregroundColor(.red)
        }
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView()
    }
}
