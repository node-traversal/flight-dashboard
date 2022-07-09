//
//  LoadableViewModelTests.swift
//  FlightDashboardTests
//
//  Created by Allen Parslow on 7/10/22.
//

import XCTest
@testable import FlightDashboard

final class LoadableViewModelTests: XCTestCase {
    @MainActor func testLoad() async throws {
        var loaded = false
        let viewModel = LoadableViewModel(state: .idle)
        
        XCTAssertEqual(viewModel.state, .idle)
        await viewModel._withLoadingState {
            XCTAssertEqual(viewModel.state, .loading)
            loaded = true
        }
        XCTAssert(loaded)
        XCTAssertEqual(viewModel.state, .loaded)
    }
    
    @MainActor func testError() async throws {
        let viewModel = LoadableViewModel(state: .idle)
        await viewModel._withLoadingState {
            throw HttpError(statusCode: 500)
        }
        
        XCTAssertEqual(viewModel.state, .error)
    }
}
