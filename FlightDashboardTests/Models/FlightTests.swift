//
//  FlightTests.swift
//  FlightDashboardTests
//
//  Created by Allen Parslow on 7/9/22.
//

import XCTest
@testable import FlightDashboard

final class FlightTests: XCTestCase {
    func testNumber() throws {
        XCTAssertEqual(ExampleFlights.empty.number, 0)
        XCTAssertEqual(ExampleFlights.inflight.number, 123)
    }
    
    func testDeparts() throws {        
        XCTAssertEqual(ExampleFlights.empty.departs, "")
        XCTAssertEqual(ExampleFlights.scheduled.departs, "2022-06-16T12:35:00Z")
        XCTAssertEqual(ExampleFlights.inflight.departs, "2022-06-16T12:45:00Z")
        XCTAssertEqual(ExampleFlights.landed.departs, "2022-06-16T12:35:00Z")
    }

    func testArrives() throws {
        XCTAssertEqual(ExampleFlights.empty.departs, "")
        XCTAssertEqual(ExampleFlights.scheduled.arrives, "2022-06-16T13:00:00Z")
        XCTAssertEqual(ExampleFlights.inflight.arrives, "2022-06-16T13:00:00Z")
        XCTAssertEqual(ExampleFlights.landed.arrives, "2022-06-16T14:01:00Z")
    }
    
    func testGateArrivesText() throws {
        XCTAssertEqual(ExampleFlights.empty.gateArrivesText, "")
        XCTAssertEqual(ExampleFlights.scheduled.gateArrivesText, "arriving at GATE 10")
        XCTAssertEqual(ExampleFlights.inflight.gateArrivesText, "arriving at GATE 10")
        XCTAssertEqual(ExampleFlights.landed.gateArrivesText, "")
    }
    
    func testGateDepartsText() throws {
        XCTAssertEqual(ExampleFlights.empty.gateDepartsText, "")
        XCTAssertEqual(ExampleFlights.scheduled.gateDepartsText, "departing from GATE 7")
        XCTAssertEqual(ExampleFlights.inflight.gateDepartsText, "left GATE 7")
        XCTAssertEqual(ExampleFlights.landed.gateDepartsText, "")
    }
    
    func testTravelTimeText() throws {
        XCTAssertEqual(ExampleFlights.empty.travelTimeText, "")
        XCTAssertEqual(ExampleFlights.scheduled.travelTimeText, "25m total travel time")
        XCTAssertEqual(ExampleFlights.inflight.travelTimeText, "15m total travel time")
        XCTAssertEqual(ExampleFlights.landed.travelTimeText, "1h 26m total travel time")
    }
    
    func testDepartureDelayText() throws {
        XCTAssertEqual(ExampleFlights.empty.departureDelayText, "")
        XCTAssertEqual(ExampleFlights.scheduled.departureDelayText, "")
        XCTAssertEqual(ExampleFlights.inflight.departureDelayText, "(10m late)")
        XCTAssertEqual(ExampleFlights.landed.departureDelayText, "")
    }
    
    func testArrivalDelayText() throws {
        XCTAssertEqual(ExampleFlights.empty.arrivalDelayText, "")
        XCTAssertEqual(ExampleFlights.scheduled.arrivalDelayText, "")
        XCTAssertEqual(ExampleFlights.inflight.arrivalDelayText, "(40m late)")
        XCTAssertEqual(ExampleFlights.landed.arrivalDelayText, "")
    }
}
