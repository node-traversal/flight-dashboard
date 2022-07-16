//
//  HomeView.swift
//  FlightDashboard
//
//  Created by Allen Parslow on 7/9/22.
//

import SwiftUI

class HomeViewModel: ObservableObject, AnalyticsRepresentable {
    @Published var trips: [TripEntry] = []
    private let logger = LogFactory.logger()
    
    let coreAirports = [Airport(id: "KDAL", code: "DAL")]
        
    var analytics: [String: AnalyticsValue] { [:] }
    
    // MARK: - public methods
    
    @MainActor
    func load(favTrip: Trip?) async {
        if let favTrip = favTrip {
            let flight = ExampleFlights.almostBoarding()
            trips = flight.tripEntries
        } else {
            trips = []
        }
    }
    
    func addTrip(origin: String, destination: String) {
        logger.notice("done searching \(origin) -> \(destination)")
    }
    
    var airport: Airport { coreAirports.first! }
}

struct HomeView: View {
    @Environment(\.horizontalSizeClass) var sizeClass
    @ObservedObject var viewModel = HomeViewModel()
    @EnvironmentObject var settings: EnvironmentSettings
    @ObservedObject var router = ViewRouter()
    @State private var showingSheet = false
    @State private var path: [Airport] = []
    
    let gradient = LinearGradient(
        gradient: Gradient(stops: [
            .init(color: .clear, location: 0),
            .init(color: .red, location: 0.9)
        ]),
        startPoint: .bottom,
        endPoint: .top
    )
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                Image("Dallas")
                    .frame(maxHeight: sizeClass == .compact ? 300 : 200, alignment: .topLeading)
                    .mask(gradient)
                    .clipped()
                HStack {
                    VStack {
                        AdaptiveStack {
                            VStack {
                                if let trip = settings.trip, settings.calc() {
//                                    HStack {
//                                        NavigationLink(destination: LoadableFlightDetailView(viewModel: FlightInfoViewModel(flightId: trip.id))
//                                            .navigationTitle("My Trip")) {
//                                                TripSummaryView(date: trip.relativeDate, trip: trip).padding(.horizontal, 10)
//                                        }
//                                    }
//                                    .padding(20.0)
//                                    .foregroundColor(.white)
//                                    .background(.blue)
//                                    .cornerRadius(10)
                                } else {
                                    Text("Add a Trip")
                                    .padding(30.0)
                                    .foregroundColor(.blue)
                                    .border(.blue)
                                }
                                ForEach(viewModel.trips) { vTrip in
                                    VStack {
                                        Text(vTrip.effectiveDate, style: .relative)
                                        TripSummaryView(date: vTrip.effectiveDate, trip: vTrip.trip).padding(.horizontal, 10)
                                    }
                                    .padding(20.0)
                                    .foregroundColor(.white)
                                    .background(.purple)
                                    .cornerRadius(10)
                                }
                            }
                            .onAppear {
                                Task {
                                    await viewModel.load(favTrip: settings.trip)
                                }
                            }
                            NavigationLink(viewModel.airport.code) {
                                AirportView(viewModel: AirportViewModel(airport: viewModel.airport.id))
                                    .navigationTitle("\(viewModel.airport.code) Airport")
                            }
                            .foregroundColor(.white)
                            .padding(30.0)
                            .background(.green)
                            .cornerRadius(10)
                        }
                        Spacer()
                    }
                    Spacer()
                }.padding()
            }.edgesIgnoringSafeArea(.top)
        }
        .environmentObject(router)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
