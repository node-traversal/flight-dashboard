//
//  ContentView.swift
//  FlightDashboard
//
//  Created by Allen Parslow on 7/9/22.
//

import SwiftUI

struct ContentView: View {
    private let tabPadding = 20.0
    
    var body: some View {
        TabView {
            HomeView().padding(.bottom, tabPadding)
                .tabItem { Label("Home", systemImage: "homekit") }
            
            AirportDelaysView()
            .padding(.bottom, tabPadding)
            .tabItem { Label("Delays", systemImage: "cloud.rain") }
            
            SettingsView().padding(.bottom, tabPadding)
            .tabItem { Label("Settings", systemImage: "gearshape") }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
