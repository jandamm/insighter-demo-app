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

	var timeIntervalSince1970: TimeInterval {
		return date.timeIntervalSince1970
	}

	private let date: Date

	// MARK: - Initialization

	init() {
		self.date = Date()
	}

	init(withDate date: Date) {
		self.date = date
	}
    
    init(withTimeInterval ti: TimeInterval) {
        self.date = Date(timeIntervalSince1970: ti)
    }

	// MARK: - Internal Methods

	func calendarWeek(beforeWeeks weeks: Int) -> String {
		return calendarWeek(inWeeks: -weeks)
	}

	func calendarWeek(inWeeks weeks: Int) -> String {
		let timeInterval: TimeInterval = Double(weeks) * 7 * 24 * 60 * 60
		let date = self.date.addingTimeInterval(timeInterval)

		return calWeek(date)
	}

	// MARK: - Private Methods

	private func calWeek(_ date: Date) -> String {
		let year = getYear(date)
		let week = getWeek(date)
		return "\(year)-\(week)"
	}

	private func getWeek(_ date: Date) -> Int {
		return CALENDAR.component(.weekOfYear, from: date)
	}

	private func getYear(_ date: Date) -> Int {
		return CALENDAR.component(.year, from: date)
	}
}

func ==(lhs: CalendarWeek, rhs: CalendarWeek) -> Bool {
	return lhs.stringValue == rhs.stringValue
}
