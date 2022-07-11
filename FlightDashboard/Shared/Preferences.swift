//
//  Preferences.swift
//  FlightDashboard
//
//  Created by Allen Parslow on 7/10/22.
//

import Foundation

public class Favorites {
    @UserDefaulted<Trip>(key: "fav.trip") var trip
}

public struct EnvironmentFlags {
    @SimpleUserDefaulted<Bool>(key: "live.api") var liveApi
}
