//
//  FlightDashboardWidgets.swift
//  FlightDashboardWidgets
//
//  Created by Allen Parslow on 7/19/22.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> TripTimelineEntry {
        TripTimelineEntry(date: Date(), label: "placeholder", trip: nil, configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (TripTimelineEntry) -> ()) {
        let entry = TripTimelineEntry(date: Date().addingTimeInterval(60*30), label: "snapshot", trip: nil, configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        createEntry(for: configuration, in: context) {
            completion(Timeline(entries: $0, policy: .atEnd))
        }
    }
    
    func createEntry(for configuration: ConfigurationIntent, in context: Context, completion: @escaping ([TripTimelineEntry]) -> Void) {
        if let favTrip = Favorites().trip {
            print("creating \(favTrip.id) timeline")
            Task {
                let api = FlightAwareAPIManager.get()
                if let flight = try? await api.getFlightInfo(flightId: favTrip.id), flight.arrives.date() > Date() {
                    let entries = flight.tripEntries.map {
                        return TripTimelineEntry(date: $0.effectiveDate, label: $0.id, trip: $0.trip, configuration: configuration)
                    }
                    completion(entries)
                } else {
                    completion([placeholder(in: context)])
                }
            }
        } else {
            print("creating default timeline")
            completion([placeholder(in: context)])
        }
    }
}

struct TripTimelineEntry: TimelineEntry {
    let date: Date
    let label: String
    let trip: Trip?
    let configuration: ConfigurationIntent
}

struct FlightDashboardWidgetsEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                TripSummaryView(date: entry.date, trip: entry.trip).padding(.horizontal, 10)
                Spacer()
            }
            #if DEBUG
                        HStack {
                            HStack() {
                                VStack(alignment: .leading) {
                                    Text("Effective:")
                                    Text(entry.date, style: .relative)
                                }
                            }.font(.caption).foregroundColor(.gray)
                            Spacer()
                        }.padding(.horizontal, 10).padding(.bottom, 1)
            #endif
        }
    }
}

@main
struct FlightDashboardWidgets: Widget {
    let kind: String = "FlightDashboardWidgets"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            FlightDashboardWidgetsEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct FlightDashboardWidgets_Previews: PreviewProvider {
    static var previews: some View {
        let date = Date().addingTimeInterval(60*30)
        let trip = Trip(
            flightNumber: "SWA123",
            origin: "DAL",
            destination: "HOU",
            state: .landing
        )
        FlightDashboardWidgetsEntryView(entry: TripTimelineEntry(date: date, label: "preview", trip: trip, configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
