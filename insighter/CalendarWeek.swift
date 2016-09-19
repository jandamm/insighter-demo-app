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
		case this, last, previous, none
	}

	// MARK: - Data

	var stringValue: String {
		return calWeek(date)
	}

	var timeIntervalSince1970: TimeInterval {
		return date.timeIntervalSince1970
	}

	fileprivate let date: Date

	// MARK: - Initialization

	init() {
		date = Date()
	}

	init(withNSDate date: Date) {
		self.date = date
	}

	// MARK: - Internal Methods

	func calenderWeekRelation(forDate inputDate: Date) -> Relation {

		switch calWeek(inputDate) {
		case stringValue:
			return .this
		case calendarWeek(beforeWeeks: 1):
			return .last
		case calendarWeek(beforeWeeks: 2):
			return .previous
		default:
			return .none
		}
	}

	func calendarWeek(beforeWeeks weeks: Double) -> String {
		return calendarWeek(inWeeks: -weeks)
	}

	func calendarWeek(inWeeks weeks: Double) -> String {
		let timeInterval: TimeInterval = weeks * 7 * 24 * 60 * 60
		let date = self.date.addingTimeInterval(timeInterval)

		return calWeek(date)
	}

	// MARK: - Private Methods

	fileprivate func calWeek(_ date: Date) -> String {
		let year = getYear(date)
		let week = getWeek(date)
		return "\(year)-\(week)"
	}

	fileprivate func getWeek(_ date: Date) -> Int {
		return CALENDAR.component(.weekOfYear, from: date)
	}

	fileprivate func getYear(_ date: Date) -> Int {
		return CALENDAR.component(.year, from: date)
	}
}

func ==(lhs: CalendarWeek, rhs: CalendarWeek) -> Bool {
	return lhs.stringValue == rhs.stringValue
}
