//
//  ContentView.swift
//  Remainder Watch App
//
//  Created by Adrian on 03.01.24.
//

import SwiftUI

struct ContentView: View {
    
    // Available unit to switch between
    private enum CountDownUnit: String{
        case day = "Day"
        case month = "Month"
        case year = "Year"
    }
    
    // our current time
    @State private var currentTime = Date() // The current Date reference to be contiusly updated
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect() // Timer for updating the count
    private var calendar = Calendar.current // reference to the user timezone
    
    // Reference to save the users selected time unit
    @State @AppStorage("Selected Count Down Unit") private var selectedCountDownUnitRaw: String = "Day"
    private var selectedCountDownUnit: CountDownUnit{
        get{
            CountDownUnit(rawValue: selectedCountDownUnitRaw) ?? .day
        }
        set{
            selectedCountDownUnitRaw = newValue.rawValue
        }
    }
    
    private var remainingText: String{
        get{
            switch selectedCountDownUnit {
            case .day:
                return "Today"
            case .month:
                return "This Month"
            case .year:
                return "This Year"
            }
        }
    }
    
    // Calculates the point in time depending on the time unit (e.g. how much time left in the day? -> targetTime is 00:00 the next day)
    private var targetTime: Date{
        get{
            switch selectedCountDownUnit {
            case .day:
                let startOfToday = calendar.startOfDay(for: self.currentTime)
                guard let startOfNextDay = calendar.date(byAdding: .day, value: 1, to: startOfToday) else {
                    fatalError("Unable to find the start of the next day.")
                }
                return startOfNextDay
                
            case .month:
                guard let startOfThisMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: self.currentTime)) else{
                    fatalError("Unable to find the start of the this month.")
                }
                guard let startOfNextMonth = calendar.date(byAdding: .month, value: 1, to: startOfThisMonth) else {
                    fatalError("Unable to calculate the start of the next month.")
                }
                return startOfNextMonth
                
            case .year:
                guard let startOfThisYear = calendar.date(from: calendar.dateComponents([.year], from: self.currentTime)) else {
                    fatalError("Unable to find the start of this year.")
                }

                guard let startOfNextYear = calendar.date(byAdding: .year, value: 1, to: startOfThisYear) else {
                    fatalError("Unable to calculate the start of the next year.")
                }
                return startOfNextYear
            }
        }
    }
    
    // Data type to contain the remaining time
    private struct RemainingTime{
        var seconds: Int = 0
        var minutes: Int = 0
        var hours: Int = 0
        var days: Int = 0
        var months: Int = 0
        
        init(seconds: Int, minutes: Int, hours: Int, days: Int, months: Int) {
            self.seconds = seconds
            self.minutes = minutes
            self.hours = hours
            self.days = days
            self.months = months
        }
    }
    
    init() {
        self.calendar.timeZone = TimeZone.current
    }
    
    
    var body: some View {
        
        VStack() {
            
            // HeaderText Stack
            HStack{
                
                Button(action: {
                    NextCountDownUnit()
                }){
                    Text("\(self.remainingText)")
                        .font(.system(size: 20))
                        .padding()
                        .background(Capsule().fill(Color.black))
                        .foregroundColor(.white)
                }
                .buttonStyle(PlainButtonStyle())
                .overlay(
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(Color.white, lineWidth: 1.5)
                        )

                                        
                VStack{
                    Spacer()
                    Text("remains...")
                        .font(
                            .system(
                                size: 15.0,
                                weight: .light,
                                design: .default)
                        )
                }
                Spacer()
            }
            
            let remainingTime = CalcRemainingTime(startTime: self.currentTime, endTime: self.targetTime, timeUnit: self.selectedCountDownUnit)
            
            // TimeDisplaying-Group
            Group{
                switch self.selectedCountDownUnit{
                case .day:
                    DayView(seconds: remainingTime.seconds , minutes: remainingTime.minutes, hours: remainingTime.hours)
                case .month:
                    MonthView(minutes: remainingTime.minutes, hours: remainingTime.hours, days: remainingTime.days)
                case .year:
                    YearView(hours: remainingTime.hours, days: remainingTime.days, months: remainingTime.months)
                }
            }
        }
        .onReceive(timer) { _ in
            self.currentTime = Date()
        }
    }
    
    func NextCountDownUnit(){
        switch selectedCountDownUnitRaw {
        case "Day":
            selectedCountDownUnitRaw = "Month"
        case "Month":
            selectedCountDownUnitRaw = "Year"
        case "Year":
            selectedCountDownUnitRaw = "Day"
        default:
            selectedCountDownUnitRaw = "Day"
        }
    }
    
    
    // Calculate the time between the startTime and endTime in second and calculates them according to timeUnit. Return the remaining time in a custom struct
    // Allows for easy modification if costum date-feature want to be implemented
    ////        1 min = 60 secs
    ////        1 hours = 3600 secs
    ////        1 day = 86400 secs
    ////        1 month = 2629800 secs
    ////        1 year = 31557600 secs
    private func CalcRemainingTime(startTime initialTime: Date, endTime targetTime: Date, timeUnit unit: CountDownUnit) -> RemainingTime {
        let totalRemainingSec = Int(initialTime.distance(to: targetTime))
        
        let remainingSec = totalRemainingSec % 60
        let remainingMin = (totalRemainingSec % 3600) / 60
        let remainingHours = unit == .day ? totalRemainingSec / 3600 : (totalRemainingSec % 86400) / 3600
        let remainingDays = unit == .month ? calendar.dateComponents([.day], from: initialTime, to: targetTime).day ?? 0 : (totalRemainingSec % 2629800) / 86400
        let remainingMonths = calendar.dateComponents([.month], from: initialTime, to:targetTime).month ?? 0
        
        return RemainingTime(seconds: remainingSec, minutes: remainingMin, hours: remainingHours, days: remainingDays, months: remainingMonths)
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
