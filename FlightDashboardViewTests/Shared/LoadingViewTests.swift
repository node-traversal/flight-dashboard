//
//  LoadingViewTests.swift
//  FlightDashboardViewTests
//
//  Created by Allen Parslow on 7/9/22.
//

import XCTest
import SwiftUI
import SnapshotTesting
@testable import FlightDashboard

final class LoadingViewTests: XCTestCase {
    func testDefaultView() throws {
        let view = LoadingView_Previews.previews
        let controller = UIHostingController(rootView: view)

        assertSnapshot(matching: controller, as: .image(on: .iPhoneX))
    }
    
    func testIdleView() throws {
        let view = LoadingView(loading: .constant(.idle), onLoad: {}) {
            Text("Loaded Content")
        }
        let controller = UIHostingController(rootView: view)

        assertSnapshot(matching: controller, as: .image(on: .iPhoneX))
    }
    
    func testErrorView() throws {
        let view = LoadingView(loading: .constant(.error), onLoad: {}) {
            Text("Loaded Content")
        }
        let controller = UIHostingController(rootView: view)

        assertSnapshot(matching: controller, as: .image(on: .iPhoneX))
    }
}
