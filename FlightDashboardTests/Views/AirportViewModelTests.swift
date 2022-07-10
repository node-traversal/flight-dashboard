//
//  AirportViewModelTests.swift
//  FlightDashboardTests
//
//  Created by Allen Parslow on 7/10/22.
//

import XCTest
@testable import FlightDashboard

final class AirportViewModelTests: XCTestCase {
    @MainActor
    func testDefaultLoad() async throws {
        let viewModel = AirportViewModel(state: .loaded, api: ExamplesFlightAwareAPI())
        await viewModel.load()
        XCTAssertEqual(ids(viewModel.flights), ids([ExampleFlights.scheduled]))
    }
    
    @MainActor
    func testDepartingLoad() async throws {
        let viewModel = AirportViewModel(state: .loaded, api: ExamplesFlightAwareAPI())
        viewModel.mode = .departing
        await viewModel.load()
        XCTAssertEqual(ids(viewModel.flights), ids([ExampleFlights.scheduled]))
    }
        
    @MainActor
    func testDepartedLoad() async throws {
        let viewModel = AirportViewModel(state: .loaded, api: ExamplesFlightAwareAPI())
        viewModel.mode = .departed
        await viewModel.load()
        XCTAssertEqual(ids(viewModel.flights), ids([ExampleFlights.inflight]))
    }
    
    @MainActor
    func testArrivingLoad() async throws {
        let viewModel = AirportViewModel(state: .loaded, api: ExamplesFlightAwareAPI())
        viewModel.mode = .arriving
        await viewModel.load()
        XCTAssertEqual(ids(viewModel.flights), ids([ExampleFlights.inflight]))
    }
    
    @MainActor
    func testArrivedLoad() async throws {
        let viewModel = AirportViewModel(state: .loaded, api: ExamplesFlightAwareAPI())
        viewModel.mode = .arrived
        await viewModel.load()
        XCTAssertEqual(ids(viewModel.flights), ids([ExampleFlights.landed, ExampleFlights.inflight]))
    }
}
