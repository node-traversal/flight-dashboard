//
//  String+DateTests.swift
//  FlightDashboardTests
//
//  Created by Allen Parslow on 7/9/22.
//

import XCTest
@testable import FlightDashboard

final class StringDateTests: XCTestCase {
    func testDay() throws {
        XCTAssertEqual("2022-06-16T04:35:00Z".date().day(TimeZone(identifier: "America/Chicago")!), "Wednesday 15-June")
    }
    
    func testDayWithAlternateTimeZone() throws {
        XCTAssertEqual("2022-06-16T04:35:00Z".date().day(TimeZone(identifier: "America/New_York")!), "Thursday 16-June")
    }
        
    func testTime() throws {
        XCTAssertEqual("2022-06-16T12:35:00Z".date().time(TimeZone(identifier: "America/Chicago")!), "7:35AM CDT")
    }
    
    func testTimeWithAlternateTimeZone() throws {
        XCTAssertEqual("2022-06-16T12:35:00Z".date().time(TimeZone(identifier: "America/New_York")!), "8:35AM EDT")
    }
        
    func testDateDifference() throws {
        let diff = "2022-06-16T05:35:00Z".date() - "2022-06-16T04:22:00Z".date()
        XCTAssertEqual(diff.hourMinute, "1h 13m")
    }
}
