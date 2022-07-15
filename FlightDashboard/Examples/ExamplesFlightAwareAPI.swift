//
//  ExamplesFlightAwareAPI.swift
//  FlightDashboard
//
//  Created by Allen Parslow on 7/10/22.
//

import Foundation

#if DEBUG
class ExamplesFlightAwareAPI: FlightAwareAPI {
    override func getDepartures(airport: String) async throws -> [Flight] {
       return [ExampleFlights.inflight]
   }
   
   override func getScheduledDepartures(airport: String) async throws -> [Flight] {
       return [ExampleFlights.scheduled]
   }
   
   override func getArrivals(airport: String) async throws -> [Flight] {
       return [ExampleFlights.inflight, ExampleFlights.landed]
   }
   
   override func getScheduledArrivals(airport: String) async throws -> [Flight] {
       return [ExampleFlights.inflight]
   }
   
   override func getAirportDelays() async throws -> [AirportDelay] {
       return ExampleDelays.allDelays
   }
}
#endif
