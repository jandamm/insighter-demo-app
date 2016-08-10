//
//  CalendarWeek.swift
//  insighter
//
//  Created by Jan Dammshäuser on 10.08.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import Foundation

struct CalendarWeek: Equatable {
    // MARK: - Data
    
    var stringValue: String {
        return calWeek(date)
    }
    
    private let date: NSDate
    
    
    // MARK: - Initialization
    
    init() {
        date = NSDate()
    }
    
    init(withNSDate date: NSDate) {
        self.date = date
    }
    
    
    // MARK: - Global Methods
    
    
    func calendarWeek(beforeWeeks weeks: Double) -> String {
        return calendarWeek(inWeeks: -weeks)
    }
    
    func calendarWeek(inWeeks weeks: Double) -> String {
        let timeInterval: NSTimeInterval = weeks * 7 * 24 * 60 * 60
        let date = self.date.dateByAddingTimeInterval(timeInterval)
        
        return calWeek(date)
    }
    
    
    // MARK: - Private Methods
    
    private func calWeek(date: NSDate) -> String {
        let year = getYear(date)
        let week = getWeek(date)
        return "\(year)-\(week)"
    }

    private func getWeek(date: NSDate) -> Int {
        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierISO8601)!
        let components = calendar.components(.WeekOfYear, fromDate: date)
        let weekNumber = components.weekOfYear
        return weekNumber
    }
    
    private func getYear(date: NSDate) -> String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy"
        return formatter.stringFromDate(date)
    }
}


func ==(lhs: CalendarWeek, rhs: CalendarWeek) -> Bool {
    return lhs.stringValue == rhs.stringValue
}
