//
//  ExampleFlights.swift
//  FlightDashboard
//
//  Created by Allen Parslow on 7/9/22.
//

import Foundation

class ExampleAirports {
    static let dal = Airport(id: "KDAL", code: "DAL")
    static let hou = Airport(id: "KHOU", code: "HOU")
    static let sat = Airport(id: "KSAT", code: "SAT")
}

class ExampleFlights {
    static let empty = Flight(
        id: "SWA42", flightNumber: "X",
        origin: ExampleAirports.dal,
        destination: ExampleAirports.sat,
        status: "NA"
    )
    
    static let scheduled = Flight(
        id: "SWA111", flightNumber: "111",
        origin: ExampleAirports.sat,
        destination: ExampleAirports.hou,
        status: "Scheduled",
        scheduledDeparts: "2022-06-16T12:35:00Z",
        scheduledArrival: "2022-06-16T13:00:00Z",
        gateDeparts: "7",
        gateArrival: "10"
    )
    
    static let inflight = Flight(
        id: "SWA123", flightNumber: "123",
        origin: ExampleAirports.dal,
        destination: ExampleAirports.hou,
        status: "Taxiing / Delayed",
        scheduledDeparts: "2022-06-16T12:35:00Z",
        scheduledArrival: "2022-06-16T13:00:00Z",
        actualDeparts: "2022-06-16T12:45:00Z",
        progress: 25,
        gateDeparts: "7",
        gateArrival: "10",
        delayDeparts: 600,
        delayArrives: 2400
    )
        
    static let landed = Flight(
        id: "SWA111", flightNumber: "111",
        origin: ExampleAirports.hou,
        destination: ExampleAirports.dal,
        status: "Scheduled",
        scheduledDeparts: "2022-06-16T12:35:00Z",
        scheduledArrival: "2022-06-16T13:00:00Z",
        actualArrival: "2022-06-16T14:01:00Z",
        progress: 100
    )
    
    static let allFlights = [scheduled, inflight, landed]
}
