//
//  Airport.swift
//  FlightDashboard
//
//  Created by Allen Parslow on 7/9/22.
//

import Foundation

struct Airport: Codable, Identifiable {
    enum CodingKeys: String, CodingKey {
        case id = "code"
        case code = "code_iata"
    }
    
    let id: String
    let code: String
    var name: String { code }
    var location: String { code }
    var timeZone: TimeZone { TimeZone.current }
}

struct DelayReason: Codable {
    enum CodingKeys: String, CodingKey {
        case text = "reason"
    }
    
    let text: String
}

struct AirportDelay: Codable, Identifiable {
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
    var name: String { code }    
    var delayReason: String { reasons.first?.text ?? "" }
}
