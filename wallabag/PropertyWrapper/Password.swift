//
//  test.swift
//  wallabag
//
//  Created by Marinel Maxime on 22/07/2019.
//

import Foundation
import WallabagCommon

@propertyWrapper
struct Password {
    
    private(set) var value: String = ""
    
    var wrappedValue: String {
        get { value }
        set { value = newValue }
    }
    
    init(initialValue: String) {
        self.wrappedValue = initialValue
    }
}
