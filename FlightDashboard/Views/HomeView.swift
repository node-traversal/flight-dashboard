//
//  HomeView.swift
//  FlightDashboard
//
//  Created by Allen Parslow on 7/9/22.
//

import SwiftUI

struct HomeView: View {
    let coreAirports = [Airport(id: "KDAL", code: "DAL")]
    
    var body: some View {
        NavigationView {
            VStack {
                Text("")
                    .navigationTitle("Dashboard")
                    .navigationBarTitleDisplayMode(.inline)
                List {
                    Section(header: Text("Core Airports")) {
                        ForEach(coreAirports) { airport in
                            NavigationLink(destination: AirportView(viewModel: AirportViewModel(airport: airport.id)).navigationTitle(airport.code)) {
                                Text("\(airport.code)")
                            }
                        }
                    }
                }
                Spacer()
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
