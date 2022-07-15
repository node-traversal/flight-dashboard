//
//  AirportView.swift
//  FlightDashboard
//
//  Created by Allen Parslow on 7/9/22.
//

import SwiftUI

class AirportViewModel: LoadableViewModel, AnalyticsRepresentable {
    enum SearchType: String, CaseIterable {
        case departing = "Departing"
        case departed = "Departed"
        case arriving = "Arriving"
        case arrived = "Arrived"
    }

    @Published var mode: AirportViewModel.SearchType
    @Published var flights: [Flight]
    @Published var favFlights: [Flight]
    
    let airport: String
    
    private var fav: Trip?
    
    init(state: LoadingState = LoadingState.idle, airport: String = "KDAL", flights: [Flight] = [Flight]()) {
        self.flights = flights
        self.favFlights = []
        self.airport = airport
        self.mode = .departing
        super.init(state: state)
        
        self.fav = favs().trip
    }
    
    // MARK: - public methods
    
    func load() async {
        await _withLoadingState {
            let flights = try await getResults()
            updateFlights(flights)
        }
    }
        
    func fav(_ flight: Flight) {
        let trip = flight.toTrip()
        self.fav = trip
        favs().trip = trip

        updateFlights(self.flights + self.favFlights)
    }
    
    var analytics: [String: AnalyticsValue] { ["airport": airport] }
    
    // MARK: - private methods
        
    private func api() -> FlightAwareAPI { FlightAwareAPIManager.get() }
    private func favs() -> Favorites { Favorites() }
        
    private func getResults() async throws -> [Flight] {
        let api = api()
        switch self.mode {
        case .departing:
            return try await api.getScheduledDepartures(airport: airport)
        case .departed:
            return try await api.getDepartures(airport: airport)
        case .arriving:
            return try await api.getScheduledArrivals(airport: airport)
        case .arrived:
            return try await api.getArrivals(airport: airport)
        }
    }
    
    private func updateFlights(_ flights: [Flight]) {
        self.flights = flights.filter { !$0.cancelled && !self.isFav($0) }.sorted { $0.departs.date() < $1.departs.date() }
        self.favFlights = flights.filter { self.isFav($0) }.sorted { $0.destination.code < $1.destination.code }
    }
    
    private func isFav(_ flight: Flight) -> Bool {
        return flight.id == self.fav?.id
    }
}

struct AirportView: View {
    @ObservedObject var viewModel: AirportViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("Select a search mode", selection: $viewModel.mode) {
                    ForEach(AirportViewModel.SearchType.allCases, id: \.self) {
                        Text($0.rawValue)
                    }
                }.pickerStyle(.segmented).onChange(of: viewModel.mode) { _ in
                    Task {
                        await viewModel.load()
                    }
                }
                .disabled(viewModel.state != .loaded)
                .trackView("AirportView", data: viewModel)
                LoadingView(loading: $viewModel.state, showList: false, onLoad: viewModel.load) {
                    List {
                        if !viewModel.favFlights.isEmpty {
                            Section(header: Text("Favorites")) {
                                ForEach(viewModel.favFlights, id: \.id) { flight in
                                    HStack {
                                        NavigationLink(destination: FlightDetailView(viewModel: FlightDetailViewModel(flight: flight)).navigationTitle("Flight Detail: \(flight.flightNumber)")) {
                                            Text(flight.destination.code).bold()
                                            Text("|  Flight: \(flight.flightNumber) \(flight.status)")
                                        }
                                    }
                                }
                            }
                        }
                        Section(header: Text("Flights")) {
                            ForEach(viewModel.flights, id: \.id) { flight in
                                HStack {
                                    NavigationLink(destination: FlightDetailView(viewModel: FlightDetailViewModel(flight: flight)).navigationTitle("Flight Detail: \(flight.flightNumber)")) {
                                        Text(flight.destination.code).bold()
                                        Text("|  Flight: \(flight.flightNumber) \(flight.status)")
                                    }
                                }.swipeActions(edge: .leading) {
                                    Button {
                                        withAnimation {
                                            viewModel.fav(flight)
                                        }
                                    } label: {
                                        Label {
                                            Text("Favorite", comment: "Favorite this flight number")
                                        } icon: {
                                            Image(systemName: "heart")
                                        }
                                    }
                                    .tint(.red)
                                }
                            }
                        }
                    }.refreshable {
                        Task {
                            await viewModel.load()
                        }
                    }
                }
                Spacer()
            }
        }
    }
}

#if DEBUG
struct AirportView_Previews: PreviewProvider {
    static var previews: some View {
        AirportView(viewModel: AirportViewModel(state: .loaded, flights: ExampleFlights.allFlights))
    }
}
#endif
