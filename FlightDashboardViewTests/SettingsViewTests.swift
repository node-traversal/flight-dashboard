//
//  SettingsViewTests.swift
//  FlightDashboardViewTests
//
//  Created by Allen Parslow on 7/9/22.
//

import XCTest
import SwiftUI
import SnapshotTesting
@testable import FlightDashboard

final class SettingsViewTests: XCTestCase {
    func testDefaultView() throws {
        let view = SettingsView_Previews.previews
        let controller = UIHostingController(rootView: view)

        assertSnapshot(matching: controller, as: .image(on: .iPhoneX))
    }
}
