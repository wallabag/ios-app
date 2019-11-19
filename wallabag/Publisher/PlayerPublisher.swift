//
//  PlayerPublisher.swift
//  wallabag
//
//  Created by Marinel Maxime on 19/11/2019.
//

import Combine
import Foundation

class PlayerPublisher: ObservableObject {
    let objectWillChange = ObservableObjectPublisher()

    var showPlayer = true
}
