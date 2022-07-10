//
//  AdaptiveStackTests.swift
//  FlightDashboardViewTests
//
//  Created by Allen Parslow on 7/10/22.
//

import XCTest
import SwiftUI
import SnapshotTesting
@testable import FlightDashboard

final class AdaptiveStackTests: XCTestCase {
    func testDefaultView() throws {
        let view = AdaptiveStack_Previews.previews
        let controller = UIHostingController(rootView: view)

        assertSnapshot(matching: controller, as: .image(on: .iPhoneX))
        assertSnapshot(matching: controller, as: .image(on: .iPhoneX(.landscape), traits: .init(horizontalSizeClass: .regular)))
    }
}
