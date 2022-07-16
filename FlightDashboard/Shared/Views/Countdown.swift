//
//  UniRelativeDate.swift
//  FlightDashboard
//
//  Created by Allen Parslow on 8/5/22.
//

import SwiftUI

// differs from style: .relative in that it will never count back up
struct Countdown<Content: View>: View {
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
        
    @State private var showShould: Bool = true
    let date: Date
    let content: () -> Content
    
    private var isFuture: Bool {
        return date > Date()
    }
    
    init(_ date: Date, content: @escaping () -> Content = { EmptyView() }) {
        self.content = content
        self.date = date
        self.showShould = isFuture
    }
    
    var body: some View {
        VStack {
            if showShould {
                Text(date, style: .relative)
            } else {
                content()

            }
        }.onReceive(timer) { input in
            showShould = isFuture // trigger state change
//            if !showShould {
//                self.timer.upstream.connect().cancel()
//            }
        }
    }
}

struct Countdown_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("This date will be in the future (initially):").bold()
                Countdown(Date().addingTimeInterval(20)) {
                    Text("Expired")
                }.padding(.bottom, 10)
                
                Text("This date is always in the past:").bold()
                Countdown(Date().addingTimeInterval(-20)) {
                    Text("Expired")
                }
                Countdown(Date().addingTimeInterval(-20)) // always hidden
            }.padding(.horizontal, 10)
            
            Spacer()
        }.padding()
    }
}
