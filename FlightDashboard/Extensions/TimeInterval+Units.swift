//
//  TimeInterval+Units.swift
//  FlightDashboard
//
//  Created by Allen Parslow on 7/9/22.
//

import Foundation

extension TimeInterval {
    var hourMinute: String {
        hours > 0 ? String(format: "%dh %dm", hours, minutes) : String(format: "%dm", minutes)
    }

    var hours: Int {
        Int((self / 3600).truncatingRemainder(dividingBy: 3600))
    }
    var minutes: Int {
        Int((self / 60).truncatingRemainder(dividingBy: 60))
    }
    var seconds: Int {
        Int(truncatingRemainder(dividingBy: 60))
    }
    var milliseconds: Int {
        Int((self * 1000).truncatingRemainder(dividingBy: 1000))
    }
}
