//
//  AirportDeplaysViewModelTests.swift
//  FlightDashboardTests
//
//  Created by Allen Parslow on 7/10/22.
//

import XCTest
@testable import FlightDashboard

final class AirportDeplaysViewModelTests: XCTestCase {
    override class func setUp() {
        super.setUp()
        FlightAwareAPIManager.configure(live: false)
    }
    
    @MainActor
    func testDefaultLoad() async throws {
        let viewModel = AirportDeplaysViewModel(state: .loaded)
        await viewModel.load()
        XCTAssertEqual(ids(viewModel.airportDelays), ids(ExampleDelays.delays))
    }
}
