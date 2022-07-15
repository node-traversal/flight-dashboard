//
//  Logger.swift
//  FlightDashboard
//
//  Created by Allen Parslow on 7/12/22.
//

import Foundation

enum AppLogCategory: String, CaseIterable, Hashable {
    case general
    case userDefaults = "USER DEFAULTS"
    case api
    case trips
    case delays
}

enum AppLogLevel {
    case disabled
    case print
    case debug
    case info
    case notice
    case warning
    case error
}

// ALSO consider adding adapter for: https://developer.apple.com/documentation/os/logger
protocol LoggerAdapter {
    func log(message: String, level: AppLogLevel, prefix: String)
}

protocol LogFactoryAdapter {
    func createLogger(_ category: AppLogCategory) -> LoggerAdapter
}

class LogFactory {
    /// links request for a given user session
    static var userExperienceId = UUID().uuidString
    
    static var isFineEnabled: Bool {
        let enabled = Bundle.main.object(forInfoDictionaryKey: "LOGGER_FINE_ENABLED") as? String
        return !(enabled?.isEmpty ?? true)
    }
    
    private static var adapters: [AppLogCategory: AppLogger] = {
        var loggers = [AppLogCategory: AppLogger]()
        AppLogCategory.allCases.forEach { category in
            loggers[category] = AppLogger(category, isFineEnabled: isFineEnabled)
        }
        
        return loggers
    }()
    
    static func configure(with logFactory: LogFactoryAdapter) {
        AppLogCategory.allCases.forEach { category in
            let adapter = logFactory.createLogger(category)
            let current = adapters[category]! // case iterated so very unexpected to crash
            adapters[category] = AppLogger(category, isFineEnabled: current.isFineEnabled, adapters: current.adapters + [adapter])
        }
    }
    
    static func logger(_ category: AppLogCategory = .general) -> AppLogger {
        return adapters[category]! // case iterated so very unexpected to crash
    }
}

struct AppLogger {
    fileprivate let isFineEnabled: Bool
    fileprivate let adapters: [LoggerAdapter]
    private let category: AppLogCategory
    
    fileprivate init(_ category: AppLogCategory, isFineEnabled: Bool, adapters: [LoggerAdapter] = []) {
        self.category = category
        self.isFineEnabled = isFineEnabled
        self.adapters = adapters
    }
    
    func text(_ message: String) {
        log(message, level: .print)
    }
    
    func debug(_ message: String) {
        log(message, level: .debug)
    }
    
    func info(_ message: String) {
        log(message, level: .info)
    }
    
    func notice(_ message: String) {
        log(message, level: .notice)
    }
    
    func warning(_ message: String) {
        log(message, level: .warning)
    }
    
    func error(_ message: String) {
        log(message, level: .error)
    }
           
    func error(_ error: Error) {
        log(error.localizedDescription, level: .error)
    }
    
    private func log(_ message: String, level: AppLogLevel = .info) {
        switch level {
#if DEBUG
        case .print:
            if isFineEnabled {
                sendMessage(message, level, prefix: "")
            }
        case .debug:
            if isFineEnabled {
                sendMessage(message, level, prefix: "")
            }
        case .info:
            sendMessage(message, level, prefix: "")
#endif
        case .notice:
            sendMessage(message, level, prefix: "")
        case .warning:
            sendMessage(message, level, prefix: "WARNING: ")
        case .error:
            break
        default:
            break
        }
    }
    
    private func sendMessage(_ message: String, _ level: AppLogLevel, prefix levelProfix: String) {
        let categoryPrefix = "[\(category.rawValue.uppercased())] "
        print("\(levelProfix)\(categoryPrefix)\(message)")
        adapters.forEach { logger in
            logger.log(message: message, level: level, prefix: levelProfix)
        }
    }
}
