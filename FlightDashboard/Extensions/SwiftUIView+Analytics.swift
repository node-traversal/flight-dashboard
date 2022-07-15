//
//  SwiftUIView+Analytics.swift
//  FlightDashboard
//
//  Created by Allen Parslow on 7/14/22.
//

import SwiftUI

private struct AnalyticsViewModifier: SwiftUI.ViewModifier {
    let analytics: Analytics

    func body(content: Content) -> some View {
        content.onAppear {
            analytics.startView()
        }
        .onDisappear {
            analytics.stopView()
        }
    }
}

private struct AnalyticsTapModifier: SwiftUI.ViewModifier {
    let actionName: String
    let requiredCount: Int
    let analytics: Analytics
    
    func body(content: Content) -> some View {
        content.simultaneousGesture(
            TapGesture(count: requiredCount).onEnded { _ in
                analytics.tap(action: actionName)
            }
        )
    }
}

extension SwiftUI.View {
    func trackView(_ name: String, data: AnalyticsRepresentable? = nil, params: [String: AnalyticsValue]? = nil) -> some View {
        var combinedParams: [String: AnalyticsValue] = [:]
        if let data = data {
            combinedParams = data.analytics
        }
        if let params = params {
            combinedParams.merge(params) { _, new in new }
        }

        return modifier(AnalyticsViewModifier(analytics: AnalyticsFactory.view(name, params: combinedParams)))
    }
    
    func trackTap(action: String, requiredCount: Int = 1) -> some View {
        let params = [
            "count": String(requiredCount)
        ]
        return modifier(AnalyticsTapModifier(actionName: action, requiredCount: requiredCount, analytics: AnalyticsFactory.view(params: params)))
    }
}
