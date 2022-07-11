//
//  ValidatedFieldTests.swift
//  FlightDashboardViewTests
//
//  Created by Allen Parslow on 7/11/22.
//

import XCTest
import SwiftUI
import SnapshotTesting
@testable import FlightDashboard

final class ValidatedFieldTests: XCTestCase {
    func testDefaultView() throws {
        let view = ValidatedField_Previews.previews
        let controller = UIHostingController(rootView: view)

        assertSnapshot(matching: controller, as: .image(on: .iPhoneX))
    }
}
