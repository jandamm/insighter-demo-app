//
//  CalendarWeek.swift
//  insighter
//
//  Created by Jan Dammshäuser on 10.08.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import Foundation

struct CalendarWeek: Equatable {
    
    enum Relation {
        case This, Last, Previous, None
    }
    
    
    // MARK: - Data
    
    var stringValue: String {
        return calWeek(date)
    }
    
    var timeIntervalSince1970: NSTimeInterval {
        return date.timeIntervalSince1970
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
    
    func calenderWeekRelation(forDate inputDate: NSDate) -> Relation {
        
        switch calWeek(inputDate) {
        case stringValue:
            return .This
        case calendarWeek(beforeWeeks: 1):
            return .Last
        case calendarWeek(beforeWeeks: 2):
            return .Previous
        default:
            return .None
        }
    }
    
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
        return CALENDAR.components(.WeekOfYear, fromDate: date).weekOfYear
    }
    
    private func getYear(date: NSDate) -> Int {
        return CALENDAR.components(.Year, fromDate: date).year
    }
}


func ==(lhs: CalendarWeek, rhs: CalendarWeek) -> Bool {
    return lhs.stringValue == rhs.stringValue
}
