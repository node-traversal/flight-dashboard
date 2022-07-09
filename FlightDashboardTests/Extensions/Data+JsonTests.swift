//
//  Data+JsonTests.swift
//  FlightDashboardTests
//
//  Created by Allen Parslow on 7/10/22.
//

import XCTest
@testable import FlightDashboard

final class DataJsonTests: XCTestCase {
    func testPrettyPrintJson() throws {
        let data = """
        {"flight":42,"status":"LANDED"}
        """.data(using: .utf8)
        
        let result = data?.prettyPrintJson ?? ""
                
        XCTAssert(result.contains("\"flight\" : 42"), result)
        XCTAssert(result.contains("\"status\" : \"LANDED\""), result)
    }
    
    func testPrettyPrintInvalidJson() throws {
        let data = "{".data(using: .utf8)
        
        let result = data?.prettyPrintJson ?? ""
                
        XCTAssertEqual(result, "")
    }
}
