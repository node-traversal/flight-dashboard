//
//  AirportDelaysView.swift
//  FlightDashboard
//
//  Created by Allen Parslow on 7/9/22.
//

import SwiftUI

class AirportDeplaysViewModel: LoadableViewModel {
    @Published var airportDelays: [AirportDelay]
    @Published var selectedAirport: AirportDelay?
    
    private let logger = LogFactory.logger(.delays)
    
    init(state: LoadingState = .idle, delays: [AirportDelay] = []) {
        self.airportDelays = ExampleDelays.delays
        super.init(state: state)
    }
    
    // MARK: - public methods
    
    func load() async {
        await _withLoadingState {
            let delays = try await api().getAirportDelays()
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
            logger.debug("Invalid color: \(code)")
            return Color.clear
        }
    }
    
    // MARK: - private methods
    
    private func api() -> FlightAwareAPI { FlightAwareAPIManager.get() }
}

struct AirportDelaysView: View {
    @ObservedObject var viewModel: AirportDeplaysViewModel = AirportDeplaysViewModel()
    @ObservedObject var router = ViewRouter()
    @State private var columnVisibility =
        NavigationSplitViewVisibility.all
    
    var body: some View {
        VStack{
            NavigationSplitView(columnVisibility: $columnVisibility) {
                HStack {
                    Text("Airport Delays")
                        .padding(.leading, 10.0)
                    Spacer()
                }
                LoadingView(loading: $viewModel.state, showList: false, onLoad: viewModel.load) {
                    VStack{

                        List(viewModel.airportDelays, selection: $viewModel.selectedAirport) { airport in
                            NavigationLink(value: airport) {
                                Text("\(airport.code)-\(airport.name)")
                            }.listRowBackground(viewModel.color(airport.colorCode))
                        }.refreshable {
                            Task {
                                await viewModel.load()
                            }
                        }
                    }.navigationSplitViewColumnWidth(
                        min: 10, ideal: 20, max: 40)
                }
            } detail: {
                NavigationStack(path: $router.path) {
                    VStack {
                        if let airport = viewModel.selectedAirport {
                            AirportView(viewModel: AirportViewModel(airport: airport.id))
                                .navigationTitle(airport.code)
                                .navigationBarTitleDisplayMode(.inline)
                        } else {
                            Text("Select an Airport")
                        }
                        Spacer()
                    }
                }.environmentObject(router)
            }
        }
    }
}

#if DEBUG
struct AirportDelaysView_Previews: PreviewProvider {
    static var previews: some View {
        AirportDelaysView(viewModel: AirportDeplaysViewModel(state: .loaded, delays: ExampleDelays.delays))
    }
}
#endif
