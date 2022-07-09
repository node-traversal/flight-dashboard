//
//  Data+Json.swift
//  FlightDashboard
//
//  Created by Allen Parslow on 7/9/22.
//

import Foundation

extension Data {
    var prettyPrintJson: String {
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
                let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
                let prettyPrintedString = String(data: data, encoding: .utf8) else { return "" }

        return prettyPrintedString
    }
}
