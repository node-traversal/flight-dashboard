//
//  AirportDeplaysViewModelTests.swift
//  FlightDashboardTests
//
//  Created by Allen Parslow on 7/10/22.
//

import XCTest
@testable import FlightDashboard

final class AirportDeplaysViewModelTests: XCTestCase {
    @MainActor
    func testDefaultLoad() async throws {
        let viewModel = AirportDeplaysViewModel(state: .loaded, api: ExamplesFlightAwareAPI())
        await viewModel.load()
        XCTAssertEqual(ids(viewModel.airportDelays), ids(ExampleDelays.delays))
    }
}
