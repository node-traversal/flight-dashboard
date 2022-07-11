//
//  Validator.swift
//  FlightDashboard
//
//  Created by Allen Parslow on 7/11/22.
//

import Foundation

public protocol Validator {
    var message: String { get }
    
    func isValid(_ value: String) -> Bool
    func isValid(_ values: [String]) -> Bool
}

// swiftlint doesn't know about the new regex expressions
// swiftlint:disable:next all
private let threeLetters = RegexValidator(regex: /^\p{L}{3}$/, message: "must be three letters")

enum Validated {
    var validator: Validator {
        switch self {
        case .airportCode:
            return threeLetters
        }
    }
    
    case airportCode
}

struct RegexValidator: Validator {
    typealias ValueType = String
    
    var regex: Regex<Substring>
    var messageText: String
    var message: String { messageText }
    
    init(regex: Regex<Substring>, message: String = "does not match") {
        self.regex = regex
        self.messageText = message
    }
    
    func isValid(_ value: String) -> Bool {
        do {
            return try regex.firstMatch(in: value) != nil
        } catch {
            return false
        }
    }
    
    func isValid(_ values: [String]) -> Bool {
        return values.allSatisfy { isValid($0) }
    }
}
