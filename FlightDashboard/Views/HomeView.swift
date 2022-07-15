//
//  HomeView.swift
//  FlightDashboard
//
//  Created by Allen Parslow on 7/9/22.
//

import SwiftUI

class HomeViewModel: ObservableObject, AnalyticsRepresentable {
    @Published private(set) var trips: [Trip] = []
    private let logger = LogFactory.logger()
    
    let coreAirports = [Airport(id: "KDAL", code: "DAL")]
    
    var analytics: [String: AnalyticsValue] { trips.first?.analytics ?? [:] }
    
    // MARK: - public methods
    
    func load() {
        if let trip = favs().trip {
            trips = [trip]
        } else {
            trips = []
        }
    }
    
    func addTrip(origin: String, destination: String) {
        let previous = trips.contains { $0.origin == origin && $0.destination == destination }
        if !previous {
            logger.notice("done searching \(origin) -> \(destination)")
            trips += [Trip(origin: origin, destination: destination)]
        }
    }
        
    // MARK: - private methods
        
    private func favs() -> Favorites { Favorites() }
}

struct HomeView: View {
    @ObservedObject var viewModel = HomeViewModel()
    @State private var showingSheet = false
 
    var body: some View {
        NavigationView {
            VStack {
                Text("")
                    .navigationTitle("Dashboard")
                    .trackView("HomeView", data: viewModel)
                    .onAppear {
                        viewModel.load()
                    }
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        Button {
                            self.showingSheet.toggle()
                        } label: {
                            Image(systemName: "plus")
                        }
                        .sheet(isPresented: $showingSheet) {
                            TripSearchView { origin, destination in
                                viewModel.addTrip(origin: origin, destination: destination)
                            }
                        }
                    }
                List {
                    if !viewModel.trips.isEmpty {
                        Section(header: Text("Trips")) {
                            ForEach(viewModel.trips) { trip in
                                HStack {
                                    switch trip.type {
                                    case .flight:
                                        Text(trip.origin ?? "").bold()
                                        Image(systemName: "airplane")
                                            .imageScale(.large)
                                            .foregroundColor(.accentColor)
                                        Text(trip.destination ?? "").bold()
                                        Text("| \(trip.id)")
                                    case .destination:
                                        Text(trip.origin ?? "").bold()
                                        Image(systemName: "airplane")
                                            .imageScale(.large)
                                            .foregroundColor(.accentColor)
                                        Text(trip.destination ?? "").bold()
                                    }
                                }
                            }
                        }
                    }
                    Section(header: Text("Core Airports")) {
                        ForEach(viewModel.coreAirports) { airport in
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
