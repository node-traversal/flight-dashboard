//
//  UserDefaultsManager.swift
//  FlightDashboard
//
//  Created by Allen Parslow on 7/10/22.
//

import Foundation

typealias Cachable = Codable & Identifiable

class UserDefaultsManager {
    private static let appGroup = "group.io.nodetraversal"
       
    private static var group: UserDefaults = {
        let userDefaults = UserDefaults(suiteName: appGroup)
        if let userDefaults = userDefaults {
            return userDefaults
        } else {
            fatalError("Failed to resolve user-defaults for app-group: \(appGroup)")
        }
    }()
            
#if DEBUG
    private static var storage = true
    
    private static var offline = {
        let userDefaults = UserDefaults(suiteName: "offline")!
        userDefaults.removePersistentDomain(forName: "offline")
        return userDefaults
    }()
#endif
        
    static func configure(storage: Bool) {
#if DEBUG
        print("WARNING: configuring user-defaults manager: \(storage)!!!!")
        self.storage = storage
#endif
    }
    
    static var shared: UserDefaults {
#if DEBUG
        if !storage {
            return offline
        }
#endif
        return group
    }
        
    static func fetch<T>(_ type: T.Type, key: String) -> T? where T : Cachable {
        guard let data: Data = UserDefaultsManager.shared.data(forKey: key) else {
            print("no data for \(key)")
            return nil
        }
        
        do {
            print("\(key):")
            print(data.prettyPrintJson)
            let value = try JSONDecoder().decode(type, from: data)
            return value
        } catch {
            print("WARNING: Failed to read \(key)")
            debugPrint(error)
            return nil
        }
    }
    

    static func write(_ entity: (any Cachable)?) {
        guard let entity = entity else { return }
        let key = "\(entity.id)"
        write(entity, key: key)
    }
    
    /// simple imlementation, could lead to many entries written, a more advanced persistent cache would implement a size limited TTL cache (for example)
    static func write(_ entity: (any Cachable)?, key: String) {
        guard let entity = entity else { return }
         
        guard let data = try? JSONEncoder().encode(entity) else {
            print("WARNING: failed to write\(key)")
            return
        }
        
        print("writing \(key):")
        print(data.prettyPrintJson)
        UserDefaultsManager.shared.set(data, forKey: key)
    }
    
    static func clear() {
        let defaults = UserDefaultsManager.shared
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
    }
}
