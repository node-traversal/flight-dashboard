//
//  FlightAwareAPITests.swift
//  FlightDashboardTests
//
//  Created by Allen Parslow on 7/10/22.
//

import XCTest
@testable import FlightDashboard

public class FakeFlightAwareRequestFactory: FlightAwareRequestFactory {
    private let data: Data
    private(set) var uri: String = "failed"
    private(set) var method: HttpMethod?
    
    init(_ data: Data) {
        self.data = data
    }
    
    override public func request<T>(_ type: T.Type, method: HttpMethod, uri: String) async throws -> T where T: Decodable {
        self.uri = uri
        self.method = method
        return try JSONDecoder().decode(type, from: data)
    }
}

final class FlightAwareAPITests: XCTestCase {
    let flights = ExampleFlights.allFlights

    private func testCase(_ encodable: Encodable) throws -> (api: FlightAwareAPI, factory: FakeFlightAwareRequestFactory) {
        let data = try JSONEncoder().encode(encodable)
        let requestFactory = FakeFlightAwareRequestFactory(data)
        
        return (api: FlightAwareAPI(requestProvider: requestFactory), factory: requestFactory)
    }
       
    func testRequest() throws {
        let requestFactory = try FlightAwareRequestFactory().request(method: .get, uri: "airports")
        XCTAssertEqual(requestFactory.url?.absoluteString ?? "fail", "https://aeroapi.flightaware.com/aeroapi/airports")
        XCTAssert(requestFactory.allHTTPHeaderFields?["x-apikey"] != nil)
    }
    
    func testInvalidRequest() throws {
        do {
             _ = try FlightAwareRequestFactory().request(method: .get, uri: "$&[]~!@$#%^&*")
             XCTFail("expected to throw an error.")
         } catch let error as FlightAwareError {
             XCTAssertEqual(error.url, "https://aeroapi.flightaware.com/aeroapi/$&[]~!@$#%^&*")
         }
    }
    
    func testArrivals() async throws {
        let test = try testCase(FlightAwareAPI.AirportArrivalsData(flights: flights))

        let flights = try await test.api.getArrivals(airport: "ABC")
        XCTAssertEqual(ids(flights), ids(flights))
        XCTAssertEqual(test.factory.uri, "/airports/ABC/flights/arrivals?airline=SWA")
        XCTAssertEqual(test.factory.method, .get)
    }
    
    func testScheduledArrivals() async throws {
        let test = try testCase(FlightAwareAPI.AirportScheduledArrivalsData(flights: flights))
        
        let flights = try await test.api.getScheduledArrivals(airport: "ABC")
        XCTAssertEqual(ids(flights), ids(flights))
        XCTAssertEqual(test.factory.uri, "/airports/ABC/flights/scheduled_arrivals?airline=SWA")
        XCTAssertEqual(test.factory.method, .get)
    }
    
    func testDepartures() async throws {
        let test = try testCase(FlightAwareAPI.AirportDeparturesData(flights: flights))
        
        let flights = try await test.api.getDepartures(airport: "ABC")
        XCTAssertEqual(ids(flights), ids(flights))
        XCTAssertEqual(test.factory.uri, "/airports/ABC/flights/departures?airline=SWA")
        XCTAssertEqual(test.factory.method, .get)
    }
    
    func testScheduledDepartures() async throws {
        let test = try testCase(FlightAwareAPI.AirportScheduledDeparturesData(flights: flights))
        
        let flights = try await test.api.getScheduledDepartures(airport: "ABC")
        XCTAssertEqual(ids(flights), ids(flights))
        XCTAssertEqual(test.factory.uri, "/airports/ABC/flights/scheduled_departures?airline=SWA")
        XCTAssertEqual(test.factory.method, .get)
    }
    
    func testAirportDelays() async throws {
        let test = try testCase(FlightAwareAPI.AirportDelaysData(delays: ExampleDelays.delays))
        
        let values = try await test.api.getAirportDelays()
        XCTAssertEqual(ids(values), ids(ExampleDelays.delays))
        XCTAssertEqual(test.factory.uri, "/airports/delays")
        XCTAssertEqual(test.factory.method, .get)
    }
}
