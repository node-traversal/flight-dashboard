//
//  ExampleFlights.swift
//  FlightDashboard
//
//  Created by Allen Parslow on 7/9/22.
//

import Foundation

#if DEBUG
class ExampleDelays {
    static let international = AirportDelay(id: "LFPG", colorCode: "none", reasons: [DelayReason(text: "non-domestic")])
    
    static let delays = [
        AirportDelay(id: "KDAL", colorCode: "red", reasons: [DelayReason(text: "due to weather")]),
        AirportDelay(id: "KSAT", colorCode: "yellow", reasons: [DelayReason(text: "due to air traffic")]),
        AirportDelay(id: "KAUS", colorCode: "none", reasons: [DelayReason(text: "invalid color")])
    ]
    
    static let allDelays = delays + [international]
}

class ExampleAirports {
    static let dal = Airport(id: "KDAL", code: "DAL")
    static let hou = Airport(id: "KHOU", code: "HOU")
    static let sat = Airport(id: "KSAT", code: "SAT")
    static let aus = Airport(id: "KAUS", code: "AUS")
    static let phx = Airport(id: "KPHX", code: "PHX")
    static let den = Airport(id: "KDEN", code: "DEN")
    
    static let all = [dal, hou, sat, aus]
    
    static func find(airport: String) -> Airport {
        return all.first { $0.id == airport }!
    }
}

class ExampleFlights {
    static var currentDate: Date { Date() }
    static var gateChangeText: String {
        let gateChange = EnvironmentFlags().gateChange ?? false
        let gateChangeText = gateChange ? "7" : "13"
        return gateChangeText
    }
    
    static let empty = Flight(
        id: "SWA-empty", flightNumber: "X",
        origin: ExampleAirports.dal,
        destination: ExampleAirports.sat,
        status: "NA"
    )
    
    static func scheduled(_ airport: String = "KDAL", gateChangeText: String = "11") -> Flight {
        return Flight(
            id: "\(airport)-scheduled", flightNumber: "101",
            origin: ExampleAirports.find(airport: airport),
            destination: ExampleAirports.phx,
            status: "Scheduled",
            scheduledDeparts: currentDate.addingTimeInterval(TimeInterval.from(hours: 2)).iso(),
            scheduledArrival: currentDate.addingTimeInterval(TimeInterval.from(hours: 3)).iso(),
            gateDeparts: gateChangeText,
            gateArrival: "10"
        )
    }
    
    static func almostBoarding(_ airport: String = "KDAL", gateChangeText: String = "11") -> Flight {
        return Flight(
            id: "\(airport)-almost-boarding", flightNumber: "110",
            origin: ExampleAirports.find(airport: airport),
            destination: ExampleAirports.den,
            status: "Scheduled / delayed",
            scheduledDeparts: currentDate.addingTimeInterval(TimeInterval.from(minutes: 3) + 2).iso(), // from(minutes: 30) + 20
            scheduledArrival: currentDate.addingTimeInterval(TimeInterval.from(hours: 1)).iso(),
            gateDeparts: gateChangeText,
            gateArrival: "10"
        )
    }
    
    static func quickBoarding(_ airport: String = "KDAL", gateChangeText: String = "11") -> Flight {
        let departs = currentDate.addingTimeInterval(30)
        
        return Flight(
            id: "\(airport)-boarding", flightNumber: "111",
            origin: ExampleAirports.find(airport: airport),
            destination: ExampleAirports.hou,
            status: "Scheduled / boarding",
            scheduledDeparts: departs.iso(),
            //scheduledDeparts: currentDate.addingTimeInterval(TimeInterval.from(minutes: 10)).iso(),
            scheduledArrival: departs.addingTimeInterval(20).iso(),
            //scheduledArrival: currentDate.addingTimeInterval(TimeInterval.from(hours: 1)).iso(),
            gateDeparts: gateChangeText,
            gateArrival: "10"
        )
    }
    
    static func boarding(_ airport: String = "KDAL", gateChangeText: String = "11") -> Flight {
        return Flight(
            id: "\(airport)-boarding", flightNumber: "112",
            origin: ExampleAirports.find(airport: airport),
            destination: ExampleAirports.hou,
            status: "Scheduled / boarding",
            scheduledDeparts: currentDate.addingTimeInterval(TimeInterval.from(minutes: 10)).iso(),
            scheduledArrival: currentDate.addingTimeInterval(TimeInterval.from(hours: 1)).iso(),
            gateDeparts: gateChangeText,
            gateArrival: "10"
        )
    }
    
    static func inflight(_ airport: String = "KDAL", gateChangeText: String = "11") -> Flight {
        return Flight(
            id: "\(airport)-inflight", flightNumber: "123",
            origin: ExampleAirports.find(airport: airport),
            destination: ExampleAirports.hou,
            status: "Taxiing / Delayed", // "En Route \/ Delayed"
            scheduledDeparts: currentDate.addingTimeInterval(TimeInterval.from(minutes: -60)).iso(),
            scheduledArrival: currentDate.addingTimeInterval(TimeInterval.from(minutes: 45)).iso(),
            actualDeparts: currentDate.addingTimeInterval(TimeInterval.from(minutes: -30)).iso(),
            progress: 25,
            gateDeparts: gateChangeText,
            gateArrival: "10",
            delayDeparts: 600,
            delayArrives: 2400
        )
    }
        
    static func landed(_ airport: String = "KDAL", gateChangeText: String = "11") -> Flight {
        return Flight(
            id: "\(airport)-landed", flightNumber: "234",
            origin: ExampleAirports.find(airport: airport),
            destination: ExampleAirports.dal,
            status: "Landed",
            scheduledDeparts: currentDate.addingTimeInterval(TimeInterval.from(minutes: -60)).iso(),
            scheduledArrival: currentDate.addingTimeInterval(TimeInterval.from(minutes: -20)).iso(),
            actualDeparts: currentDate.addingTimeInterval(TimeInterval.from(minutes: -30)).iso(),
            actualArrival: currentDate.addingTimeInterval(TimeInterval.from(minutes: -10)).iso(),
            progress: 100
        )
    }
    
    static func allFlights(_ airport: String = "KDAL") -> [Flight] {
        let text = gateChangeText
        return  [
            boarding(airport, gateChangeText: text),
            almostBoarding(airport, gateChangeText: text),
            scheduled(airport, gateChangeText: text),
            inflight(airport, gateChangeText: text),
            landed(airport, gateChangeText: text)
        ]
    }    
}
#endif
