//
//  XCTestCase+Identifiable.swift
//  FlightDashboard
//
//  Created by Allen Parslow on 7/10/22.
//

import Foundation

import XCTest

extension XCTestCase {
    func ids<T>(_ values: [T]) -> [String] where T: Identifiable {
        return values.map { return $0.id as? String ?? UUID().uuidString }
    }
}
