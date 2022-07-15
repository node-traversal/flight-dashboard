//
//  AnalyticsFactory.swift
//  FlightDashboard
//
//  Created by Allen Parslow on 7/13/22.
//

import Foundation

public typealias AnalyticsValue = String

protocol AnalyticsRepresentable {
    var analytics: [String: AnalyticsValue] { get }
}
    
protocol AnalyticsAdapter {
    func tap(action: String, params: [String: AnalyticsValue])
    func startView(key: String, name: String, params: [String: AnalyticsValue])
    func stopView(key: String, name: String, params: [String: AnalyticsValue])
    func startResourceLoading(url: String, request: URLRequest)
    func stopResourceLoading(url: String, response: URLResponse)
}

class AnalyticsFactory {
    private static var adapters: [AnalyticsAdapter] = []
    
    static func configure(with adapter: AnalyticsAdapter) {
        adapters += [adapter]
    }
    
    static func view(_ name: String = "", params: [String: AnalyticsValue] = [:]) -> Analytics {
        return Analytics(view: name, params: params, adapters: adapters)
    }
        
    static func startResourceLoading(url: String, request: URLRequest) {
        adapters.forEach { adapter in
            adapter.startResourceLoading(url: url, request: request)
        }
    }
    
    static func stopResourceLoading(url: String, response: URLResponse) {
        adapters.forEach { adapter in
            adapter.stopResourceLoading(url: url, response: response)
        }
    }
}

struct Analytics {
    private let key = UUID().uuidString
    private let adapters: [AnalyticsAdapter]
    private let view: String
    private let params: [String: AnalyticsValue]
    
    init(view: String, params: [String: AnalyticsValue], adapters: [AnalyticsAdapter]) {
        self.adapters = adapters
        self.view = view
        self.params = params
    }
    
    func startView(name: String? = nil) {
        let viewName = name ?? view
        
        #if DEBUG
        var debugName = viewName
        if LogFactory.isFineEnabled {
            debugName = "\(viewName)-\(key.suffix(6))"
        }
        #else
        let debugName = viewName
        #endif
        
        print("[UI] showing: \(debugName)")
        params.forEach { key, value in
            print("[UI]  - \(key)=\(value)")
        }
        
        if adapters.isEmpty {
            print("[UI] WARNING: no analytics configured!")
        }
        adapters.forEach { adapter in
            adapter.startView(key: key, name: viewName, params: params)
        }
    }
    
    func stopView(name: String? = nil) {
        let viewName = name ?? view
        #if DEBUG
        if LogFactory.isFineEnabled {
            print("[UI] leaving: \(viewName)-\(key.suffix(6))")
        }
        #endif
        
        adapters.forEach { adapter in
            adapter.stopView(key: key, name: viewName, params: params)
        }
    }
    
    func tap(action: String) {
        print("[UI] tapped: \(action)")
        
        adapters.forEach { adapter in
            adapter.tap(action: action, params: params)
        }
    }
}
