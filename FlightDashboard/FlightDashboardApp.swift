//
//  FlightDashboardApp.swift
//  FlightDashboard
//
//  Created by Allen Parslow on 7/9/22.
//

import SwiftUI

@main
struct FlightDashboardApp: App {
    init() {
        let env = EnvironmentFlags()
        FlightAwareAPIManager.configure(live: env.liveApi ?? false)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
