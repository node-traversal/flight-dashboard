//
//  DataDogLoggerAdapter.swift
//  FlightDashboard
//
//  Created by Allen Parslow on 7/12/22.
//

// #if DEBUG # ISSUE: integrate DATADOG_ENABLED into build, for now uncomment this line to enable datadog
#if DATADOG_ENABLED
import Foundation
import Datadog

class DataDogAdapter {
    private init() {}
    
    static func initialze() {
        guard let clientToken = Bundle.main.object(forInfoDictionaryKey: "DATADOG_CLIENT_ID") as? String else {
            print("WARNING: Datadog is not configure: DATADOG_CLIENT_ID")
            return
        }
        guard let appId = Bundle.main.object(forInfoDictionaryKey: "DATADOG_APP_ID") as? String else {
            print("WARNING: Datadog is not configure: DATADOG_APP_ID")
            return
        }

        let environment = "production"
        let serviceName = "flight-dashboard-ios"
        Datadog.initialize(
            appContext: .init(),
            trackingConsent: .granted, // ALSO consider storing via user-defaults
            configuration: Datadog.Configuration
                .builderUsing(rumApplicationID: appId, clientToken: clientToken, environment: environment)
                .set(serviceName: serviceName)
                .build()
        )
        Global.rum = RUMMonitor.initialize()

        LogFactory.configure(with: DataDogLogFactory())
        AnalyticsFactory.configure(with: DataDogAnalyticsAdapter())
    }
        
    private class DataDogLogFactory: LogFactoryAdapter {
        func createLogger(_ category: AppLogCategory) -> LoggerAdapter {
            return DataDogLoggerAdapter(category)
        }
    }

    private struct DataDogLoggerAdapter: LoggerAdapter {
        private let logger: Logger
        private let category: AppLogCategory
        
        init(_ category: AppLogCategory) {
            self.logger = Logger.builder
                .sendNetworkInfo(true)
                .sendLogsToDatadog(true)
                .set(loggerName: category.rawValue)
                .printLogsToConsole(false)
                .build()
            self.category = category
            self.logger.addAttribute(forKey: "user-experience-id", value: LogFactory.userExperienceId)
        }

        func log(message: String, level: AppLogLevel, prefix: String) {
            switch level {
            case .info:
                logger.info(message)
            case .notice:
                logger.notice(message)
            case .warning:
                logger.warn(message)
            case .error:
                logger.error(message)
            default:
                break
            }
        }
    }
    
    class DataDogAnalyticsAdapter: AnalyticsAdapter {
        func tap(action: String, params: [String: AnalyticsValue]) {
            Global.rum.addUserAction(type: .tap, name: action, attributes: params)
        }
        
        func startView(key: String, name: String, params: [String: AnalyticsValue]) {
            Global.rum.startView(key: key, name: name, attributes: params)
        }
        
        func stopView(key: String, name: String, params: [String: AnalyticsValue]) {
            Global.rum.stopView(key: key)
        }
        
        func startResourceLoading(url: String, request: URLRequest) {
            Global.rum.startResourceLoading(resourceKey: url, request: request)
        }
        
        func stopResourceLoading(url: String, response: URLResponse) {
            Global.rum.stopResourceLoading(resourceKey: url, response: response)
        }
    }
}
#else
class DataDogAdapter {
    private init() {}
    
    static func initialze() {}
}
#endif        
