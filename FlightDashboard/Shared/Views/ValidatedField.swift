//
//  ValidatedField.swift
//  FlightDashboard
//
//  Created by Allen Parslow on 7/11/22.
//

import SwiftUI

struct ValidatedField: View {
    var text: Binding<String>
    var titleKey: LocalizedStringKey
    var validator: Validator
    
    init(_ titleKey: LocalizedStringKey, text: Binding<String>, validator: Validated) {
        self.titleKey = titleKey
        self.text = text
        self.validator = validator.validator
    }
    
    var body: some View {
        VStack {
            TextField(titleKey, text: text)
            Text(validator.message).opacity(validator.isValid(text.wrappedValue) ? 0 : 1).foregroundColor(.red)
        }
    }
}

struct ValidatedField_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            ValidatedField("Bad Text", text: .constant(""), validator: .airportCode).padding(.all, 20)
            ValidatedField("Good Text", text: .constant("DAL"), validator: .airportCode).padding(.all, 20)
        }
    }
}
