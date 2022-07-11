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
        favs.trip = ExampleFlights.inflight.toTrip()
        let trip = favs.trip
        XCTAssertEqual(trip?.id, "SWA-inflight")
    }
    
    func testLiveApiOn() throws {
        var env = EnvironmentFlags()
        env.liveApi = true
        XCTAssert(env.liveApi ?? false)
    }
    
    func testLiveApiOff() throws {
        var env = EnvironmentFlags()
        env.liveApi = false
        XCTAssert(!(env.liveApi ?? true))
    }
}
