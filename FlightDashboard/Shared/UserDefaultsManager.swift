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
#if DEBUG
        LogFactory.logger(.userDefaults).warning("configuring user-defaults manager: \(storage)")
        self.storage = storage
#endif
    }
    
    static func get() -> UserDefaults {
#if DEBUG
        if !storage {
            return offline
        }
#endif
        return .standard
    }
}
