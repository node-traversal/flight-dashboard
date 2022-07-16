//
//  Trip.swift
//  FlightDashboard
//
//  Created by Allen Parslow on 7/19/22.
//

import Foundation
import SwiftUI

enum TripState: String, Codable {
    case upcoming
    case dayOfTravel = "day_of_travel"
    case wheresMyPlane = "wheres_my_plane"
    case boarding
    case inflight
    case landing
    case landed
    
    var key:String {
        return NSLocalizedString("\(self.rawValue)_status", comment: self.rawValue)
    }
    
    var tripOffset: TimeInterval {
        switch self {
        case .boarding:
            return 30
        default:
            return 0
        }
    }
}

struct TripEntry: Identifiable {
    let id: String
    let effectiveDate: Date
    let trip: Trip?
}

struct Trip: Identifiable, Codable {
    enum TripType: String, Codable {
        case flight
        case destination
    }
    
    init(origin: String, destination: String) {
        self.type = .destination
        self.origin = origin
        self.destination = destination
        self.id = "\(origin)-\(destination)"
        self.state = .upcoming
        self.relativeDate = Date().addingTimeInterval(60 * 30)
        self.gate = nil
    }
    
    init(flightNumber: String, origin: String, destination: String, state: TripState, gate: String? = nil, relativeDate: Date = Date().addingTimeInterval(60 * 30)) {
        self.type = .flight
        self.origin = origin
        self.destination = destination
        self.id = flightNumber
        self.state = state
        self.relativeDate = relativeDate
        self.gate = gate
    }
    
    let id: String
    let type: TripType
    let origin: String
    let destination: String
    let state: TripState
    let relativeDate: Date
    let gate: String?
}
