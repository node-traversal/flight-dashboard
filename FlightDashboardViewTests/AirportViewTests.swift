//
//  AirportViewTests.swift
//  FlightDashboardViewTests
//
//  Created by Allen Parslow on 7/10/22.
//

import XCTest
import SwiftUI
import SnapshotTesting
@testable import FlightDashboard

final class AirportViewTests: XCTestCase {
    func testDefaultView() throws {
        let view = AirportView_Previews.previews
        let controller = UIHostingController(rootView: view)

        assertSnapshot(matching: controller, as: .image(on: .iPhoneX))
    }
}
