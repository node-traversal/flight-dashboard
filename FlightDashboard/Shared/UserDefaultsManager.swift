//
//  UserDefaultsManager.swift
//  FlightDashboard
//
//  Created by Allen Parslow on 7/10/22.
//

import Foundation

class UserDefaultsManager {
    private static var storage = true
    private static var offline = {
        let userDefaults = UserDefaults(suiteName: "flight-dashboard-offline")!
        userDefaults.removePersistentDomain(forName: "flight-dashboard-offline")
        return userDefaults
    }()
    
    static func configure(storage: Bool) {
        print("configuring user-defaults manager: \(storage)")
        self.storage = storage
    }
    
    static func get() -> UserDefaults {
        if !storage {
            print("using offline user-defaults")
            return offline
        }
        
        print("using standard user-defaults")
        return .standard
    }
}
