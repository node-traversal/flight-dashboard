//
//  AirportDelaysView.swift
//  FlightDashboard
//
//  Created by Allen Parslow on 7/9/22.
//

import SwiftUI

class AirportDeplaysViewModel: LoadableViewModel {
    @Published private(set) var airportDelays: [AirportDelay]

    private let api: FlightAwareAPI
    
    init(state: LoadingState = .idle, api: FlightAwareAPI = FlightAwareAPI(), delays: [AirportDelay] = []) {
        self.api = api
        self.airportDelays = delays
        super.init(state: state)
    }
    
    func load() async {
        await _withLoadingState {
            let delays = try await api.getAirportDelays()
            self.airportDelays = delays.filter { $0.isDomestic }
        }
    }
    
    func color(_ code: String) -> Color {
        switch code.lowercased() {
        case "yellow":
            return Color.yellow
        case "red":
            return Color.red
        default:
            print("Invalid color: \(code)")
            return Color.white
        }
    }
}

struct AirportDelaysView: View {
    @ObservedObject var viewModel: AirportDeplaysViewModel = AirportDeplaysViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                Text("")
                    .navigationTitle("Delays")
                    .navigationBarTitleDisplayMode(.inline)
                LoadingView(loading: $viewModel.state, onLoad: viewModel.load) {
                    Section(header: Text("Airport Delays")) {
                        ForEach(viewModel.airportDelays, id: \.id) { airport in
                            NavigationLink(destination: AirportView(viewModel: AirportViewModel(airport: airport.id)).navigationTitle(airport.code)) {
                                Text("\(airport.code)-\(airport.name)")
                            }.listRowBackground(viewModel.color(airport.colorCode))
                        }
                    }
                }
            }
        }
    }
}

struct AirportDelaysView_Previews: PreviewProvider {
    static var previews: some View {
        AirportDelaysView(viewModel: AirportDeplaysViewModel(state: .loaded, delays: ExampleDelays.delays))
    }
}
