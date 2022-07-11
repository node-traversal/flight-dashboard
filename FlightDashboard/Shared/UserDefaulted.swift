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
    var storage: UserDefaults = UserDefaultsManager.get()

    var wrappedValue: Value? {
        get {
            let value = storage.value(forKey: key) as? Value
            print("user default \(key)=\(String(describing: value))")
            return value
        }
        set {
            print("setting user default \(key)=\(String(describing: newValue))")
            storage.setValue(newValue, forKey: key)
        }
    }
}

@propertyWrapper
struct UserDefaulted<ValueType: Codable> {
    let key: String
    var storage: UserDefaults = UserDefaultsManager.get()
    
    var wrappedValue: ValueType? {
        get {
            guard let data: Data = storage.data(forKey: key) else {
                print("No value stored for UserDefault \(key):")
                return nil
            }
            do {
                print("UserDefault: \(key):")
                print(data.prettyPrintJson)
                let value = try JSONDecoder().decode(ValueType.self, from: data)
                return value
            } catch {
                print("UserDefault error: \(error)")
                return nil
            }
        }
        set {
            guard let data = try? JSONEncoder().encode(newValue) else { return }
            print("Writing UserDefault \(key):")
            print(data.prettyPrintJson)
            storage.set(data, forKey: key)
        }
    }
}
