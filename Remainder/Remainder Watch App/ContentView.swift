//
//  ContentView.swift
//  Remainder Watch App
//
//  Created by Adrian on 03.01.24.
//

import SwiftUI

struct ContentView: View {
    
    // Available unit to switch between
    enum CountDownUnit: String{
        case day = "Day"
        case month = "Month"
        case year = "Year"
    }
    
    // our current time
    @State private var currentTime = Date() // The current Date reference to be contiusly updated
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect() // Timer for updating the count
    var calendar = Calendar.current // reference to the user timezone
    
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
    
    // Calculates the point in time depending on the time unit (e.g. how much time left in the day? -> targetTime is 00:00 the next day)
    private var targetTime: Date{
        get{
            switch selectedCountDownUnit {
            case .day:
                let startOfToday = calendar.startOfDay(for: self.currentTime)
                guard let startOfNextDay = calendar.date(byAdding: .day, value: 1, to: startOfToday) else {
                    fatalError("Unable to find the start of the next day.")
                }
//                print("The start of the next day is \(startOfToday)")
                return startOfNextDay
                
            case .month:
                guard let startOfThisMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: self.currentTime)) else{
                    fatalError("Unable to find the start of the this month.")
                }
                guard let startOfNextMonth = calendar.date(byAdding: .month, value: 1, to: startOfThisMonth) else {
                    fatalError("Unable to calculate the start of the next month.")
                }
//                print("The start of next month is \(startOfNextMonth)")
                return startOfNextMonth
                
            case .year:
                guard let startOfThisYear = calendar.date(from: calendar.dateComponents([.year], from: self.currentTime)) else {
                    fatalError("Unable to find the start of this year.")
                }

                guard let startOfNextYear = calendar.date(byAdding: .year, value: 1, to: startOfThisYear) else {
                    fatalError("Unable to calculate the start of the next year.")
                }
//                print("Start of the next year is \(startOfNextYear)")
                return startOfNextYear
            }
        }
    }
    
    // Data type to contain the remaining time
    private struct RemaniningTime{
        var seconds: Int = 0
        var minutes: Int = 0
        var hours: Int = 0
        var days: Int = 0
        var month: Int = 0
        
        init(seconds: Int, minutes: Int, hours: Int, days: Int, month: Int) {
            self.seconds = seconds
            self.minutes = minutes
            self.hours = hours
            self.days = days
            self.month = month
        }
    }
    
    init() {
        self.calendar.timeZone = TimeZone.current
    }
    
    
    var body: some View {
        
        VStack {
            HStack{
                Spacer().frame(width: 90)
                Button(action: {
                    NextCountDownUnit()
                }) {
                    Text("\(self.selectedCountDownUnitRaw)")
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(40)
                        .border(Color.white, width: 1)
                }
            }
            //.background(Color.blue.opacity(0.3)) // For debugging
            
            let remainingTime = CalcRemainingTime(startTime: self.currentTime, endTime: self.targetTime, timeUnit: self.selectedCountDownUnit)
            
            Group{
                switch self.selectedCountDownUnit{
                case .day:
                    DayView(seconds: remainingTime.seconds , minutes: remainingTime.minutes, hours: remainingTime.hours)
                case .month:
                    MonthView(minutes: remainingTime.minutes, hours: remainingTime.hours, days: remainingTime.days)
                case .year:
                    YearView(hours: remainingTime.hours, days: remainingTime.days, month: remainingTime.month)
                }
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        //.background(Color.red.opacity(0.3)) // For debugging
        .padding()
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
    ////        1 year = 31557600
    private func CalcRemainingTime(startTime initialTime: Date, endTime targetTime: Date, timeUnit unit: CountDownUnit) -> RemaniningTime {
        let totalRemainingSec = Int(initialTime.distance(to: targetTime))
        
        let remainingSec = totalRemainingSec % 60
        let remainingMin = (totalRemainingSec % 3600) / 60
        let remainingHours = unit == .day ? totalRemainingSec / 3600 : (totalRemainingSec % 86400) / 3600
        let remainingDays = calendar.dateComponents([.day], from: initialTime, to: targetTime).day ?? 0
        let remainingMonths = calendar.dateComponents([.month], from: initialTime, to:targetTime).month ?? 0
        
        return RemaniningTime(seconds: remainingSec, minutes: remainingMin, hours: remainingHours, days: remainingDays, month: remainingMonths)
    }
    
}
    



#Preview {
    ContentView()
}
