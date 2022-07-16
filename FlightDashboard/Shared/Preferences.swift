//
//  Preferences.swift
//  FlightDashboard
//
//  Created by Allen Parslow on 7/10/22.
//

import Foundation
import WidgetKit

class Favorites {
    @UserDefaulted<Trip>(key: "fav.trip") fileprivate(set) var trip
}

struct EnvironmentFlags {
    @SimpleUserDefaulted<Bool>(key: "live.api") fileprivate(set) var liveApi
    @SimpleUserDefaulted<Bool>(key: "change.gates") fileprivate(set) var gateChange
}

public class EnvironmentSettings: ObservableObject {
    @Published var trip: Trip? = nil
    
    @Published var liveApi: Bool = false
    @Published var gateChange: Bool = false
    @Published var shareData: Bool = false
    
    private var favs = Favorites()
    private var env = EnvironmentFlags()
    
    init() {
        load()
    }
    
    func fav(_  trip: Trip) {
        favs.trip = trip
        self.trip = trip
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    func load() {
        self.trip = favs.trip
        self.liveApi = env.liveApi ?? false
        self.gateChange = env.gateChange ?? false
    }
    
    func updateLiveApi(_ enabled: Bool) {
        let current = env.gateChange
        self.liveApi = enabled
        if current != enabled {
            env.liveApi = enabled
            FlightAwareAPIManager.configure(live: enabled)
        }
    }
    
    func updateGateChange(_ enabled: Bool) {
        let current = env.gateChange ?? false
        print("changing gates \(current)->\(enabled)")
        env.gateChange = enabled
        self.gateChange = enabled
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    func calc() -> Bool {
        print("loading: ")
        debugPrint(trip)
        return trip != nil
    }
    
    func clearUserDefaults() {
        UserDefaultsManager.clear()
        self.trip = nil
        WidgetCenter.shared.reloadAllTimelines()
    }
}
