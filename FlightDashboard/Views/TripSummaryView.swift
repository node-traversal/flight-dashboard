//
//  TripSummaryView.swift
//  FlightDashboard
//
//  Created by Allen Parslow on 7/22/22.
//

import SwiftUI

struct TripSummaryView: View {
    let date: Date
    let trip: Trip?
    
    var body: some View {
        VStack(alignment: .leading) {
            if let trip = trip {
                HStack {
                    Text(trip.origin).bold()
                    Image(systemName: "airplane")
                    Text(trip.destination).bold()
                }.foregroundColor(.blue)
                switch trip.state {
                case .upcoming:
                    Text(trip.relativeDate, style: .date)
                    Countdown(trip.relativeDate) {
                        Text("**Out of Date!**").bold().foregroundColor(.red)
                    }
                case .dayOfTravel:
                    Text("Boarding in:")
                    Countdown(trip.relativeDate) {
                        Text("BOARDING!").bold().foregroundColor(.red)
                    }
                    if let gate = trip.gate {
                        Text("GATE: \(gate)*").font(.title3)
                    }
                case .wheresMyPlane:
                    Text("Plane arriving in:").bold().foregroundColor(.red)
                    Countdown(trip.relativeDate) {
                        Text("*Arriving...*")
                    }.foregroundColor(.red)
                    if let gate = trip.gate {
                        Text("GATE: \(gate)*")
                    }
                case .boarding:
                    Text("Now Boarding!").bold()
                    if let gate = trip.gate {
                        Text("GATE: \(gate)*").font(.title3)
                    }
                case .inflight:
                    Text("Arriving in:")
                    Countdown(trip.relativeDate) {
                        Text("*Arriving...*")
                    }
                case .landing:
                    Text("Landing:")
                    Text(trip.relativeDate, style: .time)
                case .landed:
                    Text("Arrived:")
                    Text(trip.relativeDate, style: .time)
                    (Text("(") + Text(trip.relativeDate, style: .relative) + Text(" ago)")).font(.subheadline)
                }
            } else {
                Text("Favorite a trip")
            }
        }
    }
}

struct TripSummaryView_Previews: PreviewProvider {
    struct DemoTripSummaryView: View {
        let date: Date
        let title: String
        let state: TripState
        var gate: String? = nil
        
        var body: some View {
            VStack(alignment: .leading) {
                Text(title).font(.caption).bold()
                TripSummaryView(date: date, trip: Trip(flightNumber: title, origin: "DAL", destination: "HOU", state: state, gate: gate))
            }.padding(.bottom)
        }
    }
    
    static var previews: some View {
        let farDate = Date().addingTimeInterval(TimeInterval.from(days: 7))
        let closeDate = Date().addingTimeInterval(20)
        
        let demos = ExampleFlights.boarding().tripEntries
        
        Group {
            HStack {
                VStack(alignment: .leading) {
                    ForEach(demos) { demo in
                        VStack(alignment: .leading) {
                            Text(demo.effectiveDate, style: .time)
                            Text(demo.effectiveDate, style: .relative)
                            TripSummaryView(date: demo.effectiveDate, trip: demo.trip)
                        }.padding()
                    }
                }
                Spacer()
            }.padding().previewDisplayName("Widget Timeline")
            HStack {
                VStack(alignment: .leading) {
                    DemoTripSummaryView(date: farDate, title: "Upcoming Trip:", state: .upcoming)
                    DemoTripSummaryView(date: closeDate, title: "Traveling Today:", state: .dayOfTravel, gate: "14")
                    DemoTripSummaryView(date: closeDate, title: "Where's My Plane:", state: .wheresMyPlane, gate: "14")
                }
                VStack(alignment: .leading) {
                    DemoTripSummaryView(date: closeDate, title: "Boarding:", state: .boarding, gate: "14")
                    DemoTripSummaryView(date: closeDate, title: "Inflight:", state: .inflight)
                    DemoTripSummaryView(date: closeDate, title: "Landed:", state: .landed)
                }
                Spacer()
            }.padding().previewDisplayName("States")
        }
    }
}
