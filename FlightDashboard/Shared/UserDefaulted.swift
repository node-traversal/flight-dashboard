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
    private let logger = LogFactory.logger(.userDefaults)
    
    var wrappedValue: Value? {
        get {
            let value = storage.value(forKey: key) as? Value
            logger.debug("\(key)=\(String(describing: value))")
            return value
        }
        set {
            logger.debug("setting \(key)=\(String(describing: newValue))")
            storage.setValue(newValue, forKey: key)
        }
    }
}

@propertyWrapper
struct UserDefaulted<ValueType: Codable> {
    let key: String
    var storage: UserDefaults = UserDefaultsManager.get()
    private let logger = LogFactory.logger(.userDefaults)
    
    var wrappedValue: ValueType? {
        get {
            guard let data: Data = storage.data(forKey: key) else {
                logger.debug("no value stored for \(key)")
                return nil
            }
            do {
                logger.text("\(key):")
                logger.info(data.prettyPrintJson)
                let value = try JSONDecoder().decode(ValueType.self, from: data)
                return value
            } catch {
                logger.error(error)
                return nil
            }
        }
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                logger.error("failed to write\(key)")
                return
            }
            logger.text("writing \(key):")
            logger.info(data.prettyPrintJson)
            storage.set(data, forKey: key)
        }
    }
}
