//: Playground - noun: a place where people can play

import UIKit


class SettingKeys {
    static let test = SettingKey<String>("test")
}

class SettingKey<ValueType: Codable>: SettingKeys {
    let _key: String
    init(_ key: String) {
        _key = key
    }
}

class Setting {
    let defaults = UserDefaults.standard

    func get<ValueType>(for key: SettingKey<ValueType>) -> ValueType? {
        return defaults.value(forKey: key._key) as? ValueType
    }

    func set<ValueType>(for key: SettingKey<ValueType>, value: ValueType) {
        defaults.value(forKey: key._key)
        defaults.synchronize()
    }
}
Setting().set(for: .test, value: "toto")

let test = Setting().get(for: .test)

//let test: String = Setting.get(.test, type: String.self())!
