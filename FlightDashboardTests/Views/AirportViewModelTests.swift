//
//  AirportViewModelTests.swift
//  FlightDashboardTests
//
//  Created by Allen Parslow on 7/10/22.
//

import XCTest
@testable import FlightDashboard

final class AirportViewModelTests: XCTestCase {
    override class func setUp() {
        super.setUp()
        FlightAwareAPIManager.configure(live: false)
        UserDefaultsManager.configure(storage: false)
        Favorites().trip = nil
    }
    
    @MainActor
    func testDefaultLoad() async throws {
        let viewModel = AirportViewModel()
        await viewModel.load()
        XCTAssertEqual(ids(viewModel.flights), ids([ExampleFlights.scheduled]))
    }
    
    @MainActor
    func testDepartingLoad() async throws {
        let viewModel = AirportViewModel()
        viewModel.mode = .departing
        await viewModel.load()
        XCTAssertEqual(ids(viewModel.flights), ids([ExampleFlights.scheduled]))
    }
        
    @MainActor
    func testDepartedLoad() async throws {
        let viewModel = AirportViewModel()
        viewModel.mode = .departed
        await viewModel.load()
        XCTAssertEqual(ids(viewModel.flights), ids([ExampleFlights.inflight]))
    }
    
    @MainActor
    func testArrivingLoad() async throws {
        let viewModel = AirportViewModel()
        viewModel.mode = .arriving
        await viewModel.load()
        XCTAssertEqual(ids(viewModel.flights), ids([ExampleFlights.inflight]))
    }
    
    @MainActor
    func testArrivedLoad() async throws {
        let viewModel = AirportViewModel()
        viewModel.mode = .arrived
        await viewModel.load()
        XCTAssertEqual(ids(viewModel.flights), ids([ExampleFlights.landed, ExampleFlights.inflight]))
    }
}
