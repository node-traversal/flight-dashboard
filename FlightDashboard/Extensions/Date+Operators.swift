//
//  Date+Operators.swift
//  FlightDashboardTests
//
//  Created by Allen Parslow on 7/9/22.
//

import Foundation

extension Date {
    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }
}

extension Date {
    private static func format(_ date: Date?, format: String = "h:mma\ndd MMMM yyyy", zone: TimeZone? = nil) -> String {
        guard let date = date else { return "" }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        if let zone = zone {
            dateFormatter.timeZone = zone
        }
        return dateFormatter.string(from: date)
    }
    
    public func day(_ zone: TimeZone) -> String {
        return Date.format(self, format: "EEEE d-MMMM", zone: zone)
    }
    
    public func time(_ zone: TimeZone) -> String {
        return Date.format(self, format: "h:mma zzz", zone: zone)
    }
    public func iso() -> String {
        //ISO8601DateFormatter()
        return self.ISO8601Format()
    }
    
}
