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
