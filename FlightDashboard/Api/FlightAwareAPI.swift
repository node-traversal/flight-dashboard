//
//  FlightAwareAPI.swift
//  FlightTracker
//
//  Created by Allen Parslow on 7/9/22.
//

import Foundation

struct FlightAwareError: Error {
    let url: String
}

class FlightAwareRequestFactory: UrlRequestProvider {
    // App must not start if there is no api-key
    // swiftlint:disable force_cast
    private let apiKey = Bundle.main.object(forInfoDictionaryKey: "FLIGHT_AWARE_API_KEY") as! String
    // swiftlint:enable force_cast
    private let apiUrl = "https://aeroapi.flightaware.com/aeroapi"
    
    func request(method: HttpMethod, uri: String) throws -> URLRequest {
        let urlString = "\(apiUrl)/\(uri)"
        guard let requestUrl = URL(string: urlString) else {
            throw FlightAwareError(url: urlString)
        }
        
        var request = URLRequest(url: requestUrl)
        request.addValue(apiKey, forHTTPHeaderField: "x-apikey")
        
        return request
    }
    
    func request<T>(_ type: T.Type, method: HttpMethod, uri: String) async throws -> T where T: Decodable {
        return try await request(method: method, uri: uri).data(type)
    }
}

class FlightAwareAPI {
    private let provider: UrlRequestProvider

    init(requestProvider: UrlRequestProvider = FlightAwareRequestFactory()) {
        self.provider = requestProvider
    }
        
    struct AirportDeparturesData: Codable {
        private enum CodingKeys: String, CodingKey {
            case flights = "departures"
        }
        
        let flights: [Flight]
    }
    
    struct AirportArrivalsData: Codable {
        private enum CodingKeys: String, CodingKey {
            case flights = "arrivals"
        }
        
        let flights: [Flight]
    }
    
    struct AirportScheduledArrivalsData: Codable {
        private enum CodingKeys: String, CodingKey {
            case flights = "scheduled_arrivals"
        }
        
        let flights: [Flight]
    }
    
    struct AirportScheduledDeparturesData: Codable {
        private enum CodingKeys: String, CodingKey {
            case flights = "scheduled_departures"
        }
        
        let flights: [Flight]
    }
    
    struct FlightsData: Codable {
        let flights: [Flight]
    }
     
    func getDepartures(airport: String) async throws -> [Flight] {
        return try await provider.request(AirportDeparturesData.self, method: .get,
                                          uri: "/airports/\(airport)/flights/departures?airline=SWA").flights
    }
    
    func getScheduledDepartures(airport: String) async throws -> [Flight] {
        return try await provider.request(AirportScheduledDeparturesData.self, method: .get,
                                          uri: "/airports/\(airport)/flights/scheduled_departures?airline=SWA").flights
    }
    
    func getArrivals(airport: String) async throws -> [Flight] {
        return try await provider.request(AirportArrivalsData.self, method: .get,
                                          uri: "/airports/\(airport)/flights/arrivals?airline=SWA").flights
    }
    
    func getScheduledArrivals(airport: String) async throws -> [Flight] {
        return try await provider.request(AirportScheduledArrivalsData.self, method: .get,
                                          uri: "/airports/\(airport)/flights/scheduled_arrivals?airline=SWA").flights
    }
}