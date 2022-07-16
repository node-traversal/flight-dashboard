//
//  ViewRouter.swift
//  FlightDashboard
//
//  Created by Allen Parslow on 7/16/22.
//

import Foundation
import SwiftUI

class ViewRouter: ObservableObject {
    @Published var path = NavigationPath()
    
    func goHome() {
        path.removeLast(path.count)
    }
    
    func back() {
        path.removeLast()
    }
}
