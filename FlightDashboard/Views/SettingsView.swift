//
//  SettingsView.swift
//  FlightDashboard
//
//  Created by Allen Parslow on 7/9/22.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var settings: EnvironmentSettings
    
    var body: some View {
        HStack {
            VStack {
                Text("Settings")
                    .font(.title)
                    .trackView("SettingsView")
                AdaptiveStack {
#if DEBUG
                    VStack {
                        Section(header: HStack {
                            Text("Data:").bold()
                            Spacer() }
                        ) {
                            Toggle("Live API", isOn: $settings.liveApi).onChange(of: settings.liveApi) { value in
                                settings.updateLiveApi(value)
                            }
                            Toggle("Change Gates", isOn: $settings.gateChange).onChange(of: settings.gateChange) { value in
                                settings.updateGateChange(value)
                            }
                            Button("Clear User Defaults") {
                                settings.clearUserDefaults()
                            }
                         }
                    }.padding()
                    VStack {
                        Section(header: HStack {
                            Text("Features:").bold()
                            Spacer() }
                        ) {
                            Toggle("Feature A", isOn: $settings.shareData)
                            Toggle("Feature B", isOn: $settings.shareData)
                            Toggle("Feature C", isOn: $settings.shareData)
                        }
                    }.padding()
#else
                    Text("Production settings here")
#endif
                }
                Spacer()
            }.onAppear {
                settings.load()
            } 
            Spacer()
        }
        .padding(.all, 10)
    }
    
}

#if DEBUG
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
#endif
