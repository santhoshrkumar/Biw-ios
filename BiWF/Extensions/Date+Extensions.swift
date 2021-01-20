//
//  Date+Extensions.swift
//  BiWF
//
//  Created by pooja.q.gupta on 17/04/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import UIKit

extension Date {
    
    /// This will return the date to string
    /// - Parameter format: The date format in which string is returned
    func toString(withFormat format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        
        return formatter.string(from: self)
    }
    
    /// This will return the date after given days
    /// - Parameter days: Number of days
    func dateAfterDays(_ days: Int) -> Date? {
        var dayComponent = DateComponents()
        dayComponent.day = days
        let theCalendar = Calendar.current
        return theCalendar.date(byAdding: dayComponent, to: self)
    }
    
    /// This will return the date before given days
    /// - Parameter days: Number of days
    func dateBeforeDays(_ days: Int) -> Date? {
        var dayComponent = DateComponents()
        dayComponent.day = -days
        let theCalendar = Calendar.current
        return theCalendar.date(byAdding: dayComponent, to: self)
    }
    
    
    /// This will check if the current time is less than the given time
    /// - Parameter hour: hour component from time
    func isCurrentTimeLessThan(hour: Int = 0) -> Bool {
        let calendar = Calendar.current
        let currentHour = calendar.component(.hour, from: Date())
        return (currentHour < hour)
    }
    
    func startOfDay() -> Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    func startOfMonth() -> Date {
        let calendar = NSCalendar.current
        let components = calendar.dateComponents([.year, .month], from: self)
        return calendar.date(from: components) ?? self
    }
    
    func isTodayDate() -> Bool {
        let calendar = NSCalendar.current
        let todayDateComponent = calendar.dateComponents([.year, .month, .day], from: Date())
        let dateComponenet = calendar.dateComponents([.year, .month, .day], from: self)
        return (todayDateComponent.day == dateComponenet.day) && (todayDateComponent.month == dateComponenet.month) && (todayDateComponent.year == dateComponenet.year)
    }
    
    /// This will return the date after given months
    /// - Parameter month: Number of month
    func dateAfterMonth(_ month: Int) -> Date? {
       return Calendar.current.date(byAdding: .month, value: month, to: self)
    }
    
    func nearestFifteenthMinute() -> Date {
        var time = Calendar.current.dateComponents([.hour, .minute], from: Date())
        var minutes = time.minute
        let minuteUnit = ceil(Float(minutes ?? 0) / 15.0)
        minutes = Int(minuteUnit * 15.0)
        time.minute = minutes
        return Calendar.current.date(from: time) ?? Date()
    }
    
    static func createDateFromDateAndTime(from date: Date?, time: Date? ) -> Date {
        let dateComponents = Calendar.current.dateComponents([.day, .month, .year], from: date ?? Date() )
        let timeComponents = Calendar.current.dateComponents([.hour, .minute], from: time ?? Date().nearestFifteenthMinute())
        let calendar = Calendar.current
        var components = DateComponents()
        components.day = dateComponents.day
        components.month = dateComponents.month
        components.year = dateComponents.year
        components.hour = timeComponents.hour
        components.minute = timeComponents.minute
        let newDate = calendar.date(from: components)
        return newDate ?? Date()
    }
}
