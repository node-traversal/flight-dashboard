//
//  AirportView.swift
//  FlightDashboard
//
//  Created by Allen Parslow on 7/9/22.
//

import SwiftUI

class AirportViewModel: LoadableViewModel {
    enum SearchType: String, CaseIterable {
        case scheduled = "Departing"
        case inflight = "Departed"
        case arriving = "Arriving"
        case arrived = "Arrived"
    }

    @Published var mode: AirportViewModel.SearchType
    @Published var flights: [Flight]
        
    let airport: String
    
    private let api: FlightAwareAPI
        
    init(state: LoadingState = LoadingState.idle, airport: String = "KDAL", flights: [Flight] = [Flight](), api: FlightAwareAPI = FlightAwareAPI()) {
        self.flights = flights
        self.api = api
        self.airport = airport
        self.mode = .inflight
        super.init(state: state)
    }
    
    func load() async {
        await _withLoadingState {
            let flights = try await getResults()
            self.flights = flights.filter { !$0.cancelled }.sorted { $0.departs.date() < $1.departs.date() }
        }
    }
        
    private func getResults() async throws -> [Flight] {
        switch self.mode {
        case .scheduled:
            return try await api.getScheduledDepartures(airport: airport)
        case .inflight:
            return try await api.getDepartures(airport: airport)
        case .arriving:
            return try await api.getScheduledArrivals(airport: airport)
        case .arrived:
            return try await api.getArrivals(airport: airport)
        }
    }
}

struct AirportView: View {
    @ObservedObject var viewModel: AirportViewModel
    
    var body: some View {
        NavigationView {
            LoadingView(loading: $viewModel.state, onLoad: viewModel.load) {
                VStack {
                    Picker("Select a search mode", selection: $viewModel.mode) {
                        ForEach(AirportViewModel.SearchType.allCases, id: \.self) {
                            Text($0.rawValue)
                        }
                    }.pickerStyle(.segmented).onChange(of: viewModel.mode) { _ in
                        print("mode changed \(viewModel.mode)")
                        Task {
                            await viewModel.load()
                        }
                    }
                    List {
                        Section(header: Text("Flights")) {
                            ForEach(viewModel.flights, id: \.id) { flight in
                                HStack {
                                    NavigationLink(destination: FlightDetailView(viewModel: FlightDetailViewModel(flight: flight)).navigationTitle("Flight Detail: \(flight.flightNumber)")) {
                                        Text(flight.destination.code).bold()
                                        Text("|  Flight: \(flight.flightNumber) \(flight.status)")
                                    }
                                }
                            }
                        }
                    }
                    .refreshable {
                        Task {
                            await viewModel.load()
                        }
                    }
                }
            }
        }
    }
}

struct AirportView_Previews: PreviewProvider {
    static var previews: some View {
        AirportView(viewModel: AirportViewModel(state: .loaded, flights: ExampleFlights.allFlights))
    }
}
