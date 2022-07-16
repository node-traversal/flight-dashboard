//
//  PreferencesTests.swift
//  FlightDashboardTests
//
//  Created by Allen Parslow on 7/11/22.
//

import XCTest
@testable import FlightDashboard

final class PreferencesTests: XCTestCase {
    override class func setUp() {
        super.setUp()
        
        UserDefaultsManager.configure(storage: false)
    }
    
    func testFavTrip() throws {
        let favs = Favorites()
        EnvironmentSettings().fav(ExampleFlights.inflight().toTrip())
        let trip = favs.trip
        XCTAssertEqual(trip?.id, "SWA-inflight")
    }
    
    func testLiveApiOn() throws {
        var env = EnvironmentFlags()
        EnvironmentSettings().liveApi = true
        let updated = env.liveApi
        XCTAssert(env.liveApi ?? false)
    }
    
    func testLiveApiOff() throws {
        var env = EnvironmentFlags()
        EnvironmentSettings().liveApi = false
        let updated = env.liveApi ?? true
        XCTAssert(!updated)
    }
}
