//
//  TripSearchView.swift
//  FlightDashboard
//
//  Created by Allen Parslow on 7/11/22.
//

import SwiftUI

struct TripSearchView: View {
    @Environment(\.dismiss) var dismiss
    @State var origin: String = "DAL"
    @State var destination: String = "HOU"
    
    var onComplete: (_ origin: String, _ destination: String) -> Void = { _, _ in }
    
    private let validated: Validated = .airportCode
    
    func isValid() -> Bool {
        return validated.validator.isValid([origin, destination])
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    ValidatedField("Origin", text: $origin, validator: validated)
                    ValidatedField("Destination", text: $destination, validator: validated)
                    Button(action: {
                        onComplete(origin, destination)
                        dismiss()
                    }) {
                        Text("Search").frame(maxWidth: .infinity)
                    }
                    .trackTap(action: "Search")
                    .padding(.top, 10.0)
                    .buttonStyle(.borderedProminent)
                    .disabled(!isValid())
                }
            }
            .navigationTitle("Add Trip")
            .trackView("TripSearchView")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: Button("close") { dismiss() }.trackTap(action: "Dimiss"))
        }
    }
}

struct TripSearchView_Previews: PreviewProvider {
    static var previews: some View {
        TripSearchView(origin: "DAL", destination: "HOU")
    }
}
