//
//  DateExtension.swift
//  insighter
//
//  Created by Jan Dammshäuser on 09.08.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import Foundation

extension NSDate {
    
    var yearWithWeek: String {
        return "\(self.year)-\(self.week)"
    }
    
    var week: Int {
        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierISO8601)!
        let components = calendar.components(.WeekOfYear, fromDate: self)
        let weekNumber = components.weekOfYear
        return weekNumber
    }
    
    var year: String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy"
        return formatter.stringFromDate(self)
    }
}
