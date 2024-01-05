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
                print("The start of the next day is \(startOfToday)")
                return startOfNextDay
                
            case .month:
                guard let startOfThisMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: self.currentTime)) else{
                    fatalError("Unable to find the start of the this month.")
                }
                guard let startOfNextMonth = calendar.date(byAdding: .month, value: 1, to: startOfThisMonth) else {
                    fatalError("Unable to calculate the start of the next month.")
                }
                print("The start of next month is \(startOfNextMonth)")
                return startOfNextMonth
                
            case .year:
                guard let startOfThisYear = calendar.date(from: calendar.dateComponents([.year], from: self.currentTime)) else {
                    fatalError("Unable to find the start of this year.")
                }

                guard let startOfNextYear = calendar.date(byAdding: .year, value: 1, to: startOfThisYear) else {
                    fatalError("Unable to calculate the start of the next year.")
                }
                print("Start of the next year is \(startOfNextYear)")
                return startOfNextYear
            }
        }
    }
    private var remainingTime: String{
        let remainingTime = Int(currentTime.distance(to: targetTime))
        
        let remainingSec = remainingTime % 60
        var remainingMin = (remainingTime % 3600) / 60
        var remainingHours = Int(currentTime.distance(to: targetTime)) / 3600
        return "\(remainingHours):\(remainingMin):\(remainingSec)"
        
    }
    
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
            // showing the target time for debug purposes
            Text("Target time is: \(dateFormatter.string(from: self.targetTime))")
                .font(.footnote)
                .padding()
            
            
            // the Feed button
            Button(action: {
                NextCountDownUnit()
                print("switches from \(self.selectedCountDownUnitRaw) to ...")
            }) {
                Text("\(self.selectedCountDownUnitRaw)")
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.black)
                    .cornerRadius(10)
            }
            
            
            // the remaining time displayer
            Text("Remaining time is \(self.remainingTime)")
                .font(.subheadline)
        }
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
    
    
//    func displayTimeDifference(mode: CountDownUnit, currentTime: Date) -> String{
//        var endDate: Date? // either the end of the day, the end of the month or the end of the year
//        
//        switch mode{
//        case .day:
//            return "day"
//        case .month:
//            return "month"
//        case .year:
//            return "year"
//        }
//        
//    }
}













#Preview {
    ContentView()
}
