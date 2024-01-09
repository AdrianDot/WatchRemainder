//
//  ContentView.swift
//  Remainder Watch App
//
//  Created by Adrian on 03.01.24.
//

import SwiftUI

struct ContentView: View {
    
    enum CountDownUnit: String{
        case day = "Day"
        case month = "Month"
        case year = "Year"
    }
    
    // our current time
    @State private var currentTime = Date()
    // timer for updating the count
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    
    let dateFormatter = DateFormatter()
    var calendar = Calendar.current
    
        
    @State @AppStorage("Selected Count Down Unit") private var selectedCountDownUnitRaw: String = "Day"
    private var selectedCountDownUnit: CountDownUnit{
        get{
            CountDownUnit(rawValue: selectedCountDownUnitRaw) ?? .day
        }
        set{
            selectedCountDownUnitRaw = newValue.rawValue
        }
    }
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
    
    
    // DEBUG: start of struct for different remaining time units
    private struct remaningDay{
        var currentTime: Date
        var targetTime: Date
        
        var remainingSec: Int{
            Int(currentTime.distance(to: self.targetTime)) % 60
        }
        var remaningMin: Int{
            (Int(currentTime.distance(to: self.targetTime)) % 3600) / 60
        }
        var remainingHours: Int{
            Int(currentTime.distance(to: self.targetTime)) / 3600
        }
    }
    
    
    
    
    init() {
        self.dateFormatter.dateFormat = "HH:mm"
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
            
            Text("Remaining time is \(self.CalcRemainingTime())")
                .font(.subheadline)
            
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
    
    func CalcRemainingTime() -> String {
        let totalRemainingSec = Int(currentTime.distance(to: targetTime))
        
//        1 min = 60 secs
//        1 hours = 3600 secs
//        1 day = 86400 secs
//        month = 2629800 secs
        
        // Calculates the remaining time depending on the mode
        switch selectedCountDownUnit {
            
        case .day:
            let remainingSec = totalRemainingSec % 60
            let remainingMin = (totalRemainingSec % 3600) / 60
            let remainingHours = totalRemainingSec / 3600
            return "\(remainingHours) hours:\(remainingMin) min:\(remainingSec) sec"
            
        case .month:
            let remainingMin = (totalRemainingSec % 3600) / 60
            let remainingHours = (totalRemainingSec % 86400) / 3600
            
            let remainingDays = calendar.dateComponents([.day], from: currentTime, to: targetTime).day ?? (totalRemainingSec % 2629800) / 86400
            return "\(remainingDays) days:\(remainingHours) hours: \(remainingMin) min"
            
        case .year:
            let remainingHours = (totalRemainingSec % 86400) / 3600
            let remainingDays = calendar.dateComponents([.day], from: currentTime, to: targetTime).day ?? (totalRemainingSec % 2629800) / 86400
            let remainingMonths = calendar.dateComponents([.month], from: currentTime, to:targetTime).month ?? (totalRemainingSec % 31557600) / 2629800
            return " \(remainingMonths) months: \(remainingDays) days: \(remainingHours) hours"
            }
        }
    }
    



#Preview {
    ContentView()
}
