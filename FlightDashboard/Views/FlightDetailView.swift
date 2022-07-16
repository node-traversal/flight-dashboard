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
    
    var inboundFlightId: String? {
        var id: String?
        
        if flight.progress == 0 { // , flight.getState() != .boarding
            id = flight.inboundFlightId
        }
        
        return id
    }
}

class FlightInfoViewModel: LoadableViewModel {
    let flightId: String
    var flight: Flight?
    
    private func api() -> FlightAwareAPI { FlightAwareAPIManager.get() }
    
    init(state: LoadingState = .idle, flightId: String, flight: Flight? = nil) {
        self.flight = flight
        self.flightId = flightId
        super.init(state: state)
    }
    
    func load() async {
        await _withLoadingState {
            self.flight = try await api().getFlightInfo(flightId: flightId)
        }
    }
}

struct FlightDetailPopup: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: FlightInfoViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                LoadingView(loading: $viewModel.state, showList: false, onLoad: viewModel.load) {
                    HStack {
                        VStack {
                            if let flight = viewModel.flight {
                                FlightHeader(flight: flight)
                                    .padding(.bottom, 15)
                                AdaptiveStack(horizontalAlignment: .leading, verticalAlignment: .top) {
                                    DepartingFlightView(flight: flight)
                                        .padding(.bottom, 5)
                                    ArrivingFlightView(flight: flight)
                                }
                                FlightFooter(flight: flight)
                            } else {
                                Color.clear
                            }
                            Spacer()
                        }
                        Spacer()
                    }
                }
            }
            .padding(.all)
            .navigationTitle("Where's my plane?")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: Button("close") { dismiss() })
        }

    }
}

struct LoadableFlightDetailView: View {
    @ObservedObject var viewModel: FlightInfoViewModel
    @State private var showingSheet = false
    
    var body: some View {
        VStack {
            LoadingView(loading: $viewModel.state, showList: false, onLoad: viewModel.load) {
                VStack {
                    if let flight = viewModel.flight {
                        FlightDetailView(viewModel: FlightDetailViewModel(flight: flight))
                    }
                }
            }
        }
    }
}

struct FlightDetailView: View {
    @ObservedObject var viewModel: FlightDetailViewModel
    @State private var showingSheet = false
    
    var body: some View {
        VStack {
            FlightHeader(flight: viewModel.flight)
            if let flightId = viewModel.inboundFlightId {
                Button("Where's my plane?") {
                    showingSheet.toggle()
                }
                .sheet(isPresented: $showingSheet) {
                    FlightDetailPopup(viewModel: FlightInfoViewModel(flightId: flightId))
                }
            }
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
        .trackView("FlightDetailView", data: viewModel.flight)
    }
}

#if DEBUG
struct FlightDetailView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            FlightDetailView(viewModel: FlightDetailViewModel(flight: ExampleFlights.scheduled()))
                .previewDisplayName("scheduled")
            FlightDetailView(viewModel: FlightDetailViewModel(flight: ExampleFlights.almostBoarding()))
                .previewDisplayName("almost boarding")
            FlightDetailView(viewModel: FlightDetailViewModel(flight: ExampleFlights.boarding()))
                .previewDisplayName("boarding")
            FlightDetailView(viewModel: FlightDetailViewModel(flight: ExampleFlights.inflight()))
                .previewDisplayName("inflight")
        }
        
    }
}
#endif
