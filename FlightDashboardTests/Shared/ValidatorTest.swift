//
//  ValidatorTest.swift
//  FlightDashboardTests
//
//  Created by Allen Parslow on 7/11/22.
//

import XCTest
@testable import FlightDashboard

final class ValidatorTest: XCTestCase {
    func testMatches() throws {
        let validator = Validated.airportCode.validator
        XCTAssert(validator.isValid("DAL"))
        XCTAssert(validator.isValid("dal"))
        XCTAssert(validator.isValid(["dal", "HOU"]))
    }
    
    func testNotMatches() throws {
        let validator = Validated.airportCode.validator
        XCTAssert(!validator.isValid(""))
        XCTAssert(!validator.isValid("DA2"))
        XCTAssert(!validator.isValid("DA."))
        XCTAssert(!validator.isValid("DAAL"))
        XCTAssert(!validator.isValid(["", "HOU"]))
        XCTAssert(!validator.isValid(["HOU", ""]))
    }
}
