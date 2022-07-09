//
//  ContentViewTests.swift
//  FlightDashboardTests
//
//  Created by Allen Parslow on 7/9/22.
//

import XCTest
import SwiftUI
import SnapshotTesting
@testable import FlightDashboard

final class ContentViewTests: XCTestCase {
    func testContentView() throws {
        let contentView = ContentView()
        let view: UIView = UIHostingController(rootView: contentView).view

        assertSnapshot(
          matching: view,
          as: .image(size: view.intrinsicContentSize))
    }
}
