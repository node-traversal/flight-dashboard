//
//  ExamplesFlightAwareAPI.swift
//  FlightDashboard
//
//  Created by Allen Parslow on 7/10/22.
//

import Foundation

#if DEBUG
class ExamplesFlightAwareAPI: FlightAwareAPI {
    private let delay: UInt64 = 1 * 250_000_000
    
    override func getDepartures(airport: String) async throws -> [Flight] {
        try? await Task.sleep(nanoseconds: delay)
        return [ExampleFlights.inflight(airport)]
    }
    
    override func getScheduledDepartures(airport: String) async throws -> [Flight] {
        try? await Task.sleep(nanoseconds: delay)
        return [ExampleFlights.scheduled(airport), ExampleFlights.almostBoarding(airport), ExampleFlights.boarding(airport)]
    }
    
    override func getArrivals(airport: String) async throws -> [Flight] {
        try? await Task.sleep(nanoseconds: delay)
        return [ExampleFlights.landed(airport)]
    }
    
    override func getScheduledArrivals(airport: String) async throws -> [Flight] {
        try? await Task.sleep(nanoseconds: delay)
        return [ExampleFlights.inflight(airport)]
    }
    
    override func getAirportDelays() async throws -> [AirportDelay] {
        try? await Task.sleep(nanoseconds: 1 * delay)
        return ExampleDelays.allDelays
    }
    
    override func getFlightInfo(flightId: String) async throws -> Flight? {
        try? await Task.sleep(nanoseconds: delay)
        let airport = String(flightId.split(separator: "-").first ?? "")
        
        var flight: Flight? = ExampleFlights.quickBoarding()
        // var flight = UserDefaultsManager.fetch(Flight.self, key: flightId)
        
        if flight == nil {
            flight = ExampleFlights.allFlights(airport).first { $0.id == flightId }
            UserDefaultsManager.write(flight)
        }
        
        return flight
    }
}
#endif
