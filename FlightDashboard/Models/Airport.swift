//
//  Airport.swift
//  FlightDashboard
//
//  Created by Allen Parslow on 7/9/22.
//

import Foundation

struct Airport: Codable, Identifiable, Hashable {
    enum CodingKeys: String, CodingKey {
        case id = "code"
        case code = "code_iata"
    }
    
    let id: String
    let code: String
    var name: String { Airports.shared[code]?.name ?? code }
    var location: String {
        if let airport = Airports.shared[code], let city = airport.city,
            let state = airport.state {
            return "\(city), \(state)"
        }
        return code
    }
    var timeZone: TimeZone {
        if let timezone = Airports.shared[code]?.timezone {
            return TimeZone(identifier: timezone) ?? TimeZone.current
        }
        return TimeZone.current
    }
}

struct DelayReason: Codable {
    enum CodingKeys: String, CodingKey {
        case text = "reason"
    }
    
    let text: String
}

struct AirportDelay: Codable, Identifiable, Equatable, Hashable {
    static func == (lhs: AirportDelay, rhs: AirportDelay) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
      hasher.combine(id)
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "airport"
        case colorCode = "color"
        case reasons
    }
    
    let id: String
    var colorCode: String = ""
    var reasons: [DelayReason] = []
    
    var isDomestic: Bool { id.starts(with: "K") }
    var code: String { isDomestic ? String(id.dropFirst()) : "" }
    var location: AirportMeta? { Airports.shared[code] }
    var name: String { location?.name ?? code }    
    var delayReason: String { reasons.first?.text ?? "" }
}

class AirportMeta {
    let timezone: String?
    let name: String?
    let city: String?
    let state: String?
    
    init(_ map: [String: String]) {
        name = map["name"]
        timezone = map["timezone"]
        city = map["city"]
        state = map["state"]
    }
}

class Airports {
    public static let shared = Airports()
    subscript(code: String) -> AirportMeta? {
        get {
            items[code]
        }
    }
    
    var keys: [String] {
        get {
            items.keys.map { $0 }
        }
    }
    
    private var items: [String: AirportMeta] = [:]
    
    func takeoff(airports: [String: AirportMeta]) {
        items = airports
    }
}
