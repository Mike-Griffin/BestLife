//
//  Date.swift
//  BestLife
//
//  Created by Mike Griffin on 4/7/20.
//  Copyright © 2020 Mike Griffin. All rights reserved.
//

import Foundation

extension Date {
    func startOfDay() -> Date {
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local
        return calendar.startOfDay(for: self)
//        return date

    }
    
    func addCalendarSpanValue(quantity : Int, calendarSpan : Calendar.Component) -> Date {
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local
        return  calendar.date(byAdding: calendarSpan, value: quantity, to: self)!.startOfDay()
    }
    
    // test this option with the whole UTC thing though because this stuff gets weird
    // start of day function seems better and seems to do the same thing
//    func dateWithoutSeconds() -> Date {
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "dd MMMM yyyy"
//            let stringDate = dateFormatter.string(from: self)
//            return dateFormatter.date(from: stringDate)!
//    }
    
    func dateToString(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        return dateFormatter.string(from: self)
    }
    
    // Booleans to compare the current day
    
    func dateIsToday() -> Bool {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        let comparisonStringDate = dateFormatter.string(from: self)
        let todaysStringDate = dateFormatter.string(from: date)
        return comparisonStringDate == todaysStringDate
    }
    
    func dateIsYesterday() -> Bool {
        let date = Date()
        
        let calendar = Calendar.current

        let date1 = calendar.startOfDay(for: self)
        let date2 = calendar.startOfDay(for: date)

        let component = calendar.dateComponents([.day], from: date1, to: date2)
        if let numDays = component.day {
            return numDays == 1
        }
        else {
            return false
        }
    }
    
    func dateIsWithinWeek() -> Bool {
        let date = Date()
        
        let calendar = Calendar.current

        let date1 = calendar.startOfDay(for: self)
        let date2 = calendar.startOfDay(for: date)

        let component = calendar.dateComponents([.day], from: date1, to: date2)
        if let numDays = component.day {
            return numDays <= 7
        }
        else {
            return false
        }

    }
}
