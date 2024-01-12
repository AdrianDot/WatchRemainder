//
//  TimeUnitViews.swift
//  Remainder Watch App
//
//  Created by Adrian on 12.01.24.
//

import SwiftUI

struct DayView: View {
    let seconds: Int
    let minutes: Int
    let hours: Int
    
    var body: some View {
        Text("\(self.hours) hours: \(minutes) minutes: \(seconds) seconds")
        
    }
}

struct MonthView: View{
    let minutes: Int
    let hours: Int
    let days: Int
    
    var body: some View {
        Text("\(self.days) days: \(self.hours) hours: \(self.minutes) minutes")
    }
}

struct YearView: View{
    let hours: Int
    let days: Int
    let months: Int
    
    var body: some View {
        Text("\(self.months) month: \(self.days) days: \(self.hours) hours")
    }
}

#Preview {
    DayView(seconds: 10, minutes: 20, hours: 11)
//    MonthView(minutes: 20, hours: 11, days: 20)
//    YearView(hours: 20, days: 15, months: 4)
    
}
