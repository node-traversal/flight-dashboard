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
        env.liveApi = enabled
        FlightAwareAPIManager.configure(live: enabled)
    }
}

struct SettingsView: View {
    @ObservedObject var viewModel = SettingsViewModel()
    
    var body: some View {
        NavigationView {
            HStack {
                Text("")
                .navigationTitle("Settings")
                .navigationBarTitleDisplayMode(.inline)
                VStack {
                    HStack {
                        Toggle("Live API", isOn: $viewModel.liveApi).onChange(of: viewModel.liveApi) { value in
                            viewModel.updateLiveApi(value)
                        }
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

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
