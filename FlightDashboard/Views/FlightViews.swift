//
//  FlightViews.swift
//  FlightDashboard
//
//  Created by Allen Parslow on 7/9/22.
//

import SwiftUI

struct FlightHeader: View {
    @State var now = TimeInterval()
    let timer = Timer.publish(every: 1, on: .current, in: .common).autoconnect()
    var flight: Flight
    
    var body: some View {
        VStack {
            HStack {
                Text(flight.origin.code).bold()
                Image(systemName: "airplane")
                    .imageScale(.large)
                    .foregroundColor(.accentColor)
                Text(flight.destination.code).bold()
            }
            .padding([.top, .leading, .bottom], 0.0)
            Text(flight.status.uppercased()).foregroundColor(Color.green).bold()
        }
    }
}

struct FlightFooter: View {
    var flight: Flight
    
    var body: some View {
        VStack {
            ProgressView(value: flight.progress / 100).frame(height: 20)
            Text(flight.travelTimeText)
        }
    }
}

struct DepartingFlightView: View {
    var flight: Flight
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("\(flight.origin.name)-\(flight.origin.code)")
                Text(flight.origin.location.uppercased()).bold()
                if flight.gateDeparts != nil {
                    Text(flight.gateDepartsText)
                }
                
                Text(flight.departs.date().day(flight.origin.timeZone))
                HStack {
                    Text(flight.departs.date().time(flight.origin.timeZone).uppercased()).bold()
                    Text(flight.departureDelayText).foregroundColor(.red).bold().brightness(0.1)
                    Spacer()
                }
            }
            Spacer()
        }
        .padding(.all, 10.0)
        .background(.blue).foregroundColor(.white)
        .cornerRadius(15)
    }
}

struct ArrivingFlightView: View {
    var flight: Flight
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("\(flight.destination.name)-\(flight.destination.code)")
                Text(flight.destination.location.uppercased()).bold()
                if flight.gateArrival != nil {
                    Text(flight.gateArrivesText)
                }
                Text(flight.arrives.date().day(flight.destination.timeZone))
                HStack {
                    Text(flight.arrives.date().time(flight.destination.timeZone).uppercased()).bold()
                    Text(flight.arrivalDelayText).foregroundColor(.red).bold()
                    Spacer()
                }
            }
            Spacer()
        }
        .padding(.all, 10.0)
        .background(.green).foregroundColor(.white)
        .cornerRadius(15)
    }
}

struct FlightViews_Previews: PreviewProvider {
    static var previews: some View {
        let flight = ExampleFlights.inflight
        
        VStack {
            FlightHeader(flight: flight)
            AdaptiveStack {
                DepartingFlightView(flight: flight)
                ArrivingFlightView(flight: flight)
            }
            FlightFooter(flight: flight)
        }
        .padding(.all)
    }
}
