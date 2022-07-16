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
    
    init(state: LoadingState = LoadingState.idle, airport: String = "KDAL", flights: [Flight] = [Flight]()) {
        self.flights = flights
        self.favFlights = []
        self.airport = airport
        self.mode = .departing
        super.init(state: state)
    }
    
    // MARK: - public methods
    
    func load(_ trip: Trip?) async {
        await _withLoadingState {
            let flights = try await getResults()
            updateFlights(flights, fav: trip)
        }
    }
    
    var analytics: [String: AnalyticsValue] { [
        "airport": airport,
        "loading": self.state.rawValue,
        "flights": String(self.flights.count)
    ] }
    
    // MARK: - private methods
        
    private func api() -> FlightAwareAPI { FlightAwareAPIManager.get() }
        
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
    
    private func updateFlights(_ flights: [Flight], fav: Trip?) {
        self.flights = flights.filter { !$0.cancelled && $0.id != fav?.id }.sorted { $0.departs.date() < $1.departs.date() }
        self.favFlights = flights.filter { $0.id == fav?.id  }.sorted { $0.destination.code < $1.destination.code }
        print("\(self.state.rawValue)-\(self.flights.count)")
    }
    
    func updateFavTrip(fav: Trip?) {
        updateFlights(self.flights + self.favFlights, fav: fav)
    }
}

struct AirportView: View {
    @ObservedObject var viewModel: AirportViewModel
    @EnvironmentObject var settings: EnvironmentSettings
    
    func load() async {
        await viewModel.load(settings.trip)
    }
    
    var body: some View {
        VStack {
            Picker("Select a search mode", selection: $viewModel.mode) {
                ForEach(AirportViewModel.SearchType.allCases, id: \.self) {
                    Text($0.rawValue)
                }
            }.pickerStyle(.segmented).onChange(of: viewModel.mode) { _ in
                Task {
                    await viewModel.load(settings.trip)
                }
            }
            .disabled(viewModel.state != .loaded)
            VStack {
                LoadingView(loading: $viewModel.state, showList: false, onLoad: load) {
                    List {
                        if !viewModel.favFlights.isEmpty {
                            Section(header: Text("Favorites")) {
                                ForEach(viewModel.favFlights, id: \.id) { flight in
                                    HStack {
                                        NavigationLink(destination: FlightDetailView(viewModel: FlightDetailViewModel(flight: flight)).navigationTitle("Flight #\(flight.number)")) {
                                            Text(flight.destination.code).bold()
                                            Text("|  Flight: \(flight.flightNumber) \(flight.status)")
                                        }
                                    }
                                }
                            }
                        }
                        Section(header: Text("Flights")) {
                            ForEach(viewModel.flights) { flight in
                                HStack {
                                    NavigationLink(destination: FlightDetailView(viewModel: FlightDetailViewModel(flight: flight)).navigationTitle("Flight #\(flight.number)")) {
                                        HStack {
                                            Text(flight.destination.code).frame(width: 60).bold()
                                            Divider()
                                            Text("Flight: \(flight.flightNumber) \(flight.status)")
                                        }
                                    }
                                }.swipeActions(edge: .leading) {
                                    Button {
                                        withAnimation {
                                            let trip = flight.toTrip()
                                            settings.fav(trip)
                                            viewModel.updateFavTrip(fav: trip)
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
                            await load()
                        }
                    }
                }
            }
        }
    }
    
}

#if DEBUG
struct AirportView_Previews: PreviewProvider {
    static var previews: some View {
        AirportView(viewModel: AirportViewModel(state: .loaded, flights: ExampleFlights.allFlights()))
    }
}
#endif
