//
//  String+Date.swift
//  FlightDashboard
//
//  Created by Allen Parslow on 7/9/22.
//

import Foundation

extension String {
    public func date() -> Date {
        return ISO8601DateFormatter().date(from: self) ?? Date(timeIntervalSince1970: 0)
    }
}
