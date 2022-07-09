//
//  FlightDetailView.swift
//  FlightDashboard
//
//  Created by Allen Parslow on 7/9/22.
//

import SwiftUI

class FlightDetailViewModel: ObservableObject {
    @Published var flight: Flight
    
    init(flight: Flight) {
        self.flight = flight
    }
}

struct FlightDetailView: View {
    @ObservedObject var viewModel: FlightDetailViewModel
    @State private var showingSheet = false
    
    var body: some View {
        VStack {
            FlightHeader(flight: viewModel.flight)
            AdaptiveStack(horizontalAlignment: .leading, verticalAlignment: .top) {
                DepartingFlightView(flight: viewModel.flight)
                    .padding(.bottom, 5)
                ArrivingFlightView(flight: viewModel.flight)
            }
            FlightFooter(flight: viewModel.flight)
            Spacer()
        }
        .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
        .frame(maxWidth: .infinity)
    }
}

struct FlightDetailView_Previews: PreviewProvider {
    static var previews: some View {
        FlightDetailView(viewModel: FlightDetailViewModel(flight: ExampleFlights.inflight))
    }
}
