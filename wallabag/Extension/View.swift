//
//  View.swift
//  wallabag
//
//  Created by Marinel Maxime on 18/05/2020.
//

import Foundation
import SwiftUI

extension View {
    func openInSafari(_ url: String?) {
        guard let path = url, let url = URL(string: path) else { return }
        UIApplication.shared.open(url)
    }
}
