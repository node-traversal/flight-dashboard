//
//  Flight.swift
//  FlightDashboard
//
//  Created by Allen Parslow on 7/9/22.
//

import Foundation

struct Flight: Codable, Identifiable {
    enum CodingKeys: String, CodingKey {
        case id = "ident"
        case flightNumber = "flight_number"
        case status
        case origin
        case destination
        case scheduledDeparts = "scheduled_out"
        case scheduledArrival = "scheduled_in"
        case actualDeparts = "actual_out"
        case estimatedDeparts = "estimated_out"
        case estimatedArrival = "estimated_in"
        case progress = "progress_percent"
        case gateDeparts = "gate_origin"
        case gateArrival = "gate_destination"
        case inboundFlightId = "inbound_fa_flight_id"
        case eta = "filed_ete"
        case delayDeparts = "departure_delay"
        case delayArrives = "arrival_delay"
        case cancelled
    }
    
    let id: String
    let flightNumber: String
    let origin: Airport
    let destination: Airport
    var status = ""
    var scheduledDeparts: String?
    var scheduledArrival: String?
    var actualDeparts: String?
    var actualArrival: String?
    var estimatedDeparts: String?
    var estimatedArrival: String?
    var progress: Double = 0.0
    var gateDeparts: String?
    var gateArrival: String?
    var inboundFlightId: String?
    var eta: TimeInterval = 0
    var delayDeparts: TimeInterval = 0
    var delayArrives: TimeInterval = 0
    var cancelled: Bool = false
    
    var number: Int { Int(flightNumber) ?? 0 }
    var departs: String { actualDeparts ?? estimatedDeparts ?? scheduledDeparts ?? "" }
    var arrives: String { actualArrival ?? estimatedArrival ?? scheduledArrival ?? "" }
    var gateArrivesText: String { gateArrival != nil ? "arriving at GATE \(gateArrival!)" : "" }
    var gateDepartsText: String { gateDeparts != nil ?  (progress == 0 ? "departing from GATE \(gateDeparts!)" : "left GATE \(gateDeparts!)") : "" }
    var departureDelayText: String { delayDeparts > 0 ? "(\(delayDeparts.hourMinute) late)" : "" }
    var arrivalDelayText: String { delayArrives > 0 ? "(\(delayArrives.hourMinute) late)" : "" }
    var travelTimeText: String {
        let diff: TimeInterval = arrives.date() - departs.date()
        if diff > 0 {
            return "\(diff.hourMinute) total travel time"
        }
        
        return ""
    }
    
    func toTrip() -> Trip { Trip(flightNumber: id, origin: origin.code, destination: destination.code) }
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
    }
    
    init(flightNumber: String, origin: String, destination: String) {
        self.type = .flight
        self.origin = origin
        self.destination = destination
        self.id = flightNumber
    }
    
    var id: String
    let type: TripType
    let origin: String?
    let destination: String?
}

extension Trip: AnalyticsRepresentable {
    var analytics: [String: AnalyticsValue] {
        [
            "origin": origin ?? "N/A",
            "destination": destination ?? "N/A"
        ]
    }
}

extension Flight: AnalyticsRepresentable {
    var analytics: [String: AnalyticsValue] {
        [
            "origin": origin.code,
            "destination": destination.code,
            "flightNumber": flightNumber
        ]
    }
}
