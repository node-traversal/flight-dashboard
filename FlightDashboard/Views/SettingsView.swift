//
//  SettingsView.swift
//  FlightDashboard
//
//  Created by Allen Parslow on 7/9/22.
//

import SwiftUI

class SettingsViewModel: ObservableObject {
    @Published var liveApi: Bool = false
    
    private var env = EnvironmentFlags()
    
    init() {
    }
    
    func load() {
        liveApi = env.liveApi ?? true
    }
    
    func updateLiveApi(_ enabled: Bool) {
        let current = env.liveApi
        if current != enabled {
            env.liveApi = enabled
            FlightAwareAPIManager.configure(live: enabled)
        }
    }
}

struct SettingsView: View {
    @ObservedObject var viewModel = SettingsViewModel()
    
    var body: some View {
        NavigationView {
            HStack {
                Text("")
                .navigationTitle("Settings")
                .trackView("SettingsView")
                .navigationBarTitleDisplayMode(.inline)
                VStack {
                    HStack {
#if DEBUG
                        Toggle("Live API", isOn: $viewModel.liveApi).onChange(of: viewModel.liveApi) { value in
                            viewModel.updateLiveApi(value)
                        }
#else
                        Text("Production settings here")
#endif
                    }
                    Spacer()
                }.onAppear {
                    viewModel.load()
                }
                Spacer()
            }
            .padding(.all, 10)
        }
    }
}

#if DEBUG
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
#endif
