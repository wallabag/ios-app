//
//  SettingMock.swift
//  wallabagTests
//
//  Created by maxime marinel on 15/04/2019.
//

import Foundation
import WallabagCommon

class SettingMock: SettingProtocol {
    var getValues: [String: Any]
    var settedValues: [String: String] = [:]

    init(_ getValues: [String: Any] = [:]) {
        self.getValues = getValues
    }

    func get<ValueType>(for key: SettingKey<ValueType>) -> ValueType {
        guard let value = getValues[key.key] as? ValueType else {
            return ("" as! ValueType)
        }

        return value
    }

    func set<ValueType>(_ value: ValueType, for key: SettingKey<ValueType>) {
        settedValues[key.key] = (value as! String)
    }

    func set(password _: String, username _: String) {}
}
