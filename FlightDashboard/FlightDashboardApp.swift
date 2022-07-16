//
//  FlightDashboardApp.swift
//  FlightDashboard
//
//  Created by Allen Parslow on 7/9/22.
//

import SwiftUI
import FirebaseCore

@main
struct FlightDashboardApp: App {
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    @StateObject var settings = EnvironmentSettings()
    var notificationCenter = AppNotificationCenter()
    
    init() {
        DataDogAdapter.initialze()
        let liveApi = false // EnvironmentFlags().liveApi ?? false
        FlightAwareAPIManager.configure(live: liveApi)
        Airports.shared.takeoff(airports: ExampleAirportStore.airports)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView().onAppear {
                notificationCenter.settings = settings
                DispatchQueue.main.async {
                    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
                        print("Permission granted: \(granted)")
                        DispatchQueue.main.async {
                            UIApplication.shared.registerForRemoteNotifications()                                                    }
                    }
                }
            }.environmentObject(settings)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data)          {
        let token = deviceToken.map { data in String(format: "%02.2hhx", data) }.joined()
        print("Device Token: \(token)")
    }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error.localizedDescription)
    }
}

class AppNotificationCenter: NSObject, ObservableObject {
    var settings: EnvironmentSettings? = nil
    override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }
}

extension AppNotificationCenter: UNUserNotificationCenterDelegate  {
    func userNotificationCenter(_ center: UNUserNotificationCenter, openSettingsFor notification: UNNotification?) { }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        guard let settings = settings else {
            print("WARNING: settings was not configured! on AppNotificationCenter")
            return
        }
        
        let userInfo = notification.request.content.userInfo
        
        guard let aps = userInfo["aps"] as? [String: AnyObject], let gate = aps["gate"] as? String else {
            print("------------------")
            print("Ignored Push Notification: ")
            debugPrint(userInfo)
            print("------------------")
            return
        }
        let changeGates = gate == "change"
        print("Changing gates: \(gate) -> \(changeGates)")

        settings.updateGateChange(changeGates)
        if changeGates {
            settings.trip = ExampleFlights.almostBoarding(gateChangeText: ExampleFlights.gateChangeText).toTrip()
        } else {
            settings.trip = ExampleFlights.boarding(gateChangeText: ExampleFlights.gateChangeText).toTrip()
        }
        
        completionHandler([.banner, .sound, .badge])
    }
}
