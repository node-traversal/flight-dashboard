//
//  LoadingView.swift
//  FlightDashboard
//
//  Created by Allen Parslow on 7/9/22.
//

import SwiftUI

struct LoadingView<Content: View>: View {
    var loading: Binding<LoadingState>
    var showList: Bool = true
    var onLoad: () async -> Void = {}
    var content: () -> Content
    
    @State private var loaded = false
    
    var body: some View {
        VStack {
            switch loading.wrappedValue {
            case .idle:
                Color.clear.onAppear {
                    Task {
                        guard !loaded else { return }
                        await onLoad()
                        loaded = true
                    }
                }
            case .loading:
                ProgressView()
            case .loaded:
                if showList {
                    List {
                        content()
                    }.refreshable {
                        Task {
                            await onLoad()
                        }
                    }
                } else {
                    content()
                }                
            case .error:
                Text("Error!").foregroundColor(.red)
            }
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView(loading: .constant(.loaded)) {
            Text("Loaded Content")
        }
    }
}
