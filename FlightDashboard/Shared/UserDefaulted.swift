//
//  UserDefaulted.swift
//  FlightDashboard
//
//  Created by Allen Parslow on 7/10/22.
//

import Foundation

@propertyWrapper
struct SimpleUserDefaulted<Value> {
    let key: String
    var storage: UserDefaults = UserDefaultsManager.shared
    
    var wrappedValue: Value? {
        get {
            let value = storage.value(forKey: key) as? Value
            print("\(key)=\(String(describing: value))")
            return value
        }
        set {
            print("setting \(key)=\(String(describing: newValue))")
            storage.setValue(newValue, forKey: key)
        }
    }
}

@propertyWrapper
struct UserDefaulted<ValueType: Cachable> {
    let key: String
    var storage: UserDefaults = UserDefaultsManager.shared
    
    var wrappedValue: ValueType? {
        get {
            return UserDefaultsManager.fetch(ValueType.self, key: key)
        }
        set {
            UserDefaultsManager.write(newValue, key: key)
        }
    }
}
