//
//  TimeUnitViews.swift
//  Remainder Watch App
//
//  Created by Adrian on 12.01.24.
//

import SwiftUI



// Day View
struct DayView: View {
    let seconds: Int
    let minutes: Int
    let hours: Int
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 0){
            Group{
                // hours
                Text("\(self.hours)")
                    .font(
                        .system(
                            size: 70.0,
                            weight: .bold,
                            design: .default)
                    )
                + Text("h")
                    .font(
                        .system(
                            size: 40.0,
                            weight: .light,
                            design: .default)
                    )
            }
            .padding(.vertical, -10)
            
            Group{
                // minutes
                Text("\(self.minutes)")
                    .font(
                        .system(
                            size: 45.0,
                            weight: .light,
                            design: .default)
                    )
                + Text("min")
                    .font(
                    .system(
                        size: 20.0,
                        weight: .light,
                        design: .rounded)
                )
            }
            .padding(.vertical, -10)
            
            Group{
                // seconds
                Text("\(self.seconds)")
                    .font(
                    .system(
                        size: 30.0,
                        weight: .ultraLight,
                        design: .default)
                )
                + Text(" sec")
                    .font(
                    .system(
                        size: 20.0,
                        weight: .ultraLight,
                        design: .default)
                )
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}


// Month View
struct MonthView: View{
    let minutes: Int
    let hours: Int
    let days: Int
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 0){
            Group{
                // hours
                Text("\(self.days)")
                    .font(
                        .system(
                            size: 70.0,
                            weight: .bold,
                            design: .default)
                    )
                + Text("days")
                    .font(
                        .system(
                            size: 40.0,
                            weight: .light,
                            design: .default)
                    )
            }
            .padding(.vertical, -10)
            
            
            Group{
                // minutes
                Text("\(self.hours)")
                    .font(
                        .system(
                            size: 45.0,
                            weight: .light,
                            design: .default)
                    )
                + Text("h")
                    .font(
                    .system(
                        size: 20.0,
                        weight: .light,
                        design: .rounded)
                )
            }
            .padding(.vertical, -10)
            
            
            Group{
                // seconds
                Text("\(self.minutes)")
                    .font(
                    .system(
                        size: 30.0,
                        weight: .ultraLight,
                        design: .default)
                )
                + Text(" min")
                    .font(
                    .system(
                        size: 20.0,
                        weight: .ultraLight,
                        design: .default)
                )
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        
    }
}


// Year View
struct YearView: View{
    let hours: Int
    let days: Int
    let months: Int
    
    var body: some View {
            
            VStack(alignment: .leading, spacing: 0){
                Group{
                    // hours
                    Text("\(self.months)")
                        .font(
                            .system(
                                size: 70.0,
                                weight: .bold,
                                design: .default)
                        )
                    + Text("months")
                        .font(
                            .system(
                                size: 40.0,
                                weight: .light,
                                design: .default)
                        )
                }
                .padding(.vertical, -10)
                
                
                Group{
                    // minutes
                    Text("\(self.days)")
                        .font(
                            .system(
                                size: 45.0,
                                weight: .light,
                                design: .default)
                        )
                    + Text("days")
                        .font(
                        .system(
                            size: 20.0,
                            weight: .light,
                            design: .rounded)
                    )
                }
                .padding(.vertical, -10)
                
                Group{
                    // seconds
                    Text("\(self.hours)")
                        .font(
                        .system(
                            size: 30.0,
                            weight: .ultraLight,
                            design: .default)
                    )
                    + Text(" hours")
                        .font(
                        .system(
                            size: 20.0,
                            weight: .ultraLight,
                            design: .default)
                    )
                }

            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
}

#Preview {
    DayView(seconds: 10, minutes: 20, hours: 7)
//    MonthView(minutes: 20, hours: 11, days: 20)
//    YearView(hours: 20, days: 15, months: 4)
    
}
