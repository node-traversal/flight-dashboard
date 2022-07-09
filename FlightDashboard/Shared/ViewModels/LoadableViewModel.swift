//
//  LoadableViewModel.swift
//  FlightDashboard
//
//  Created by Allen Parslow on 7/9/22.
//

import Foundation

enum LoadingState {
    case idle
    case loading
    case loaded
    case error
}

@MainActor
class LoadableViewModel: ObservableObject {
    @Published var state: LoadingState = .idle
    
    init(state: LoadingState) {
        self.state = state
    }
            
    func _withLoadingState(load: () async throws -> Void) async {
        self.state = .loading
        
        do {
            try await load()
            self.state = .loaded
        } catch {
            print(error)
            self.state = .error
        }
    }
}
