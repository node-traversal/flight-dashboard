//
//  Flight.swift
//  FlightDashboard
//
//  Created by Allen Parslow on 7/9/22.
//

import Foundation

struct Flight: Codable, Identifiable, Hashable {
    private static let boardingTime = 1
    
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
    
    func toTrip() -> Trip { Trip(flightNumber: id, origin: origin.code, destination: destination.code, state: .upcoming) }
    
    var boardingDate: Date {
        return departs.date().addingTimeInterval(-10)
        //return departs.date().addingTimeInterval(TimeInterval.from(minutes: -Double(Flight.boardingTime)))
    }
    
    func getState(_ currentDate: Date = Date()) -> TripState {
        guard scheduledDeparts != nil else { return .upcoming }
        guard actualArrival == nil else { return .landed }
        
        let date = departs.date()
        guard Calendar.current.isDateInToday(date) else { return .upcoming }
        
        var state: TripState = .dayOfTravel
        
        if progress <= 0 {
            let timeToBoard: TimeInterval = boardingDate - currentDate
            let countDown = timeToBoard.minutes
            if countDown <= 0 {
                state = .boarding
            }
        } else {
            state = .inflight
            if let estimatedArrival = estimatedArrival, date > estimatedArrival.date()  {
                state = .landed
            }
        }
        
        return state
    }
                            
    private func createTripEntry(state: TripState, effectiveDate: Date, endDate: Date) -> TripEntry {
        return TripEntry(id: state.rawValue, effectiveDate: effectiveDate, trip: Trip(
            flightNumber: id,
            origin: origin.code,
            destination: destination.code,
            state: state,
            gate: gateDeparts,
            relativeDate: endDate
        ))
    }
    
//    var debugTripEntries: [TripEntry] {
//        let now = Date()
//        let boardingTime = now.addingTimeInterval(20)
//        // let boardingTime = now.addingTimeInterval(-50) // landed
//        // let boardingTime = now.addingTimeInterval(-25) // arriving
//        // let boardingTime = now.addingTimeInterval(-10) // boarding
//        // let boardingTime = now.addingTimeInterval(20) // default
//        // let boardingTime = now.addingTimeInterval(TimeInterval.from(hours: 2))
//        // let boardingTime = now.addingTimeInterval(TimeInterval.from(days: 2))
//        let departureTime = boardingTime.addingTimeInterval(20)
//        let arrivalTime = departureTime.addingTimeInterval(20)
//        let dayOfTravel = Calendar(identifier: .gregorian).startOfDay(for: departureTime).addingTimeInterval(TimeInterval.from(hours: 1))
//        var entries: [TripEntry] = []
//
//        if now < dayOfTravel {
//            entries.append(createTripEntry(state: .upcoming, effectiveDate: now, endDate: departureTime))
//        }
//        if now < boardingTime {
//            entries.append(createTripEntry(state: .dayOfTravel, effectiveDate: dayOfTravel, endDate: boardingTime))
//        }
//        if now < departureTime {
//            entries.append(createTripEntry(state: .boarding, effectiveDate: boardingTime.addingTimeInterval(-10), endDate: departureTime))
//        }
//        if now < arrivalTime {
//            entries.append(createTripEntry(state: .inflight, effectiveDate: departureTime, endDate: arrivalTime))
//        }
//
//        entries.append(createTripEntry(state: .landing, effectiveDate: arrivalTime.addingTimeInterval(-10), endDate: arrivalTime))
//        entries.append(createTripEntry(state: .landed, effectiveDate: arrivalTime.addingTimeInterval(10), endDate: arrivalTime))
//
//        return entries
//    }
    
    var tripEntries: [TripEntry] {
        let now = Date()
        let boardingTime = boardingDate
        let departureTime = departs.date()
        let arrivalTime = arrives.date()
        let dayOfTravel = Calendar(identifier: .gregorian).startOfDay(for: departureTime).addingTimeInterval(TimeInterval.from(hours: 1))
        var entries: [TripEntry] = []
        
        if now < dayOfTravel {
            entries.append(createTripEntry(state: .upcoming, effectiveDate: now, endDate: departureTime))
        }
        if now < boardingTime {
            entries.append(createTripEntry(state: .dayOfTravel, effectiveDate: dayOfTravel, endDate: boardingTime))
        }
        if now < departureTime {
            entries.append(createTripEntry(state: .boarding, effectiveDate: boardingTime.addingTimeInterval(-10), endDate: departureTime))
        }
        if now < arrivalTime {
            entries.append(createTripEntry(state: .inflight, effectiveDate: departureTime, endDate: arrivalTime))
        }
        
        entries.append(createTripEntry(state: .landing, effectiveDate: arrivalTime.addingTimeInterval(-10), endDate: arrivalTime))
        entries.append(createTripEntry(state: .landed, effectiveDate: arrivalTime.addingTimeInterval(10), endDate: arrivalTime))
        entries.append(TripEntry(id: "finished", effectiveDate: arrivalTime.addingTimeInterval(20), trip: nil))
        
        return entries
    }
}

extension Trip: AnalyticsRepresentable {
    var analytics: [String: AnalyticsValue] {
        [
            "origin": origin,
            "destination": destination
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
