//
//  TimeInterval+UnitsTests.swift
//  FlightDashboardTests
//
//  Created by Allen Parslow on 7/10/22.
//

import XCTest
@testable import FlightDashboard

final class TimeInterval_UnitsTests: XCTestCase {
    func testZero() throws {
        let interval: TimeInterval = 0
        
        XCTAssertEqual(interval.milliseconds, 0)
        XCTAssertEqual(interval.seconds, 0)
        XCTAssertEqual(interval.minutes, 0)
        XCTAssertEqual(interval.hours, 0)
        XCTAssertEqual(interval.hourMinute, "0m")
    }
    
    func testMS() throws {
        let interval: TimeInterval = 0.1
        
        XCTAssertEqual(interval.milliseconds, 100)
        XCTAssertEqual(interval.seconds, 0)
        XCTAssertEqual(interval.minutes, 0)
        XCTAssertEqual(interval.hours, 0)
        XCTAssertEqual(interval.hourMinute, "0m")
    }
    
    func test10Seconds() throws {
        let interval: TimeInterval = 10
        
        XCTAssertEqual(interval.milliseconds, 0)
        XCTAssertEqual(interval.seconds, 10)
        XCTAssertEqual(interval.minutes, 0)
        XCTAssertEqual(interval.hours, 0)
        XCTAssertEqual(interval.hourMinute, "0m")
    }
    
    func test10Minutes() throws {
        let interval: TimeInterval = 10 * 60
        
        XCTAssertEqual(interval.milliseconds, 0)
        XCTAssertEqual(interval.seconds, 0)
        XCTAssertEqual(interval.minutes, 10)
        XCTAssertEqual(interval.hours, 0)
        XCTAssertEqual(interval.hourMinute, "10m")
    }
    
    func test10Hours() throws {
        let interval: TimeInterval = 10 * 60 * 60
        
        XCTAssertEqual(interval.milliseconds, 0)
        XCTAssertEqual(interval.seconds, 0)
        XCTAssertEqual(interval.minutes, 0)
        XCTAssertEqual(interval.hours, 10)
        XCTAssertEqual(interval.hourMinute, "10h 0m")
    }
}
