//
//  UserData.swift
//  insighter
//
//  Created by Jan Dammshäuser on 09.08.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import Foundation

struct UserData: Equatable, FIRUploadable {
	let UID: String
	let company: String?
	let score: Double
	let lastRated: LastRated
	let lastRatedDate: CalendarWeek
	let securityQuestion: String?
	let securityAnswer: String?

	var scoreString: String {
		return score.asScore
	}

	// MARK: - Initialization

	init(UID: String, company: String?, score: Double?, lastRated: Int?, lastRatedDate: TimeInterval?, securityQuestion: String?, securityAnswer: String?) {
		self.UID = UID
		self.company = company
		self.score = score ?? 0
		self.securityAnswer = securityAnswer
		self.securityQuestion = securityQuestion
		self.lastRated = LastRated(realValue: lastRated, relationDate: lastRatedDate)

		let lastRatedDate = lastRatedDate ?? 0
		self.lastRatedDate = CalendarWeek(withTimeInterval: lastRatedDate)
	}

	// MARK: - FIRUploadable

	var FIR_PATH: String {
		return "\(DBPathKeys.user.rawValue)/\(UID)"
	}

	var uploadData: [String: AnyObject] {
		let key = DBValueKeys.User.self
		var out = [String: AnyObject]()

		if let company = company {
			out[key.company.rawValue] = company as AnyObject
		}
		if score > 0 {
			out[key.score.rawValue] = key as AnyObject
		}
		if lastRated.realValue > 0 {
			out[key.lastRated.rawValue] = lastRated.realValue as AnyObject
		}
		if lastRatedDate.timeIntervalSince1970 > 0 {
			out[key.lastRatedDate.rawValue] = lastRatedDate.timeIntervalSince1970 as AnyObject
		}
		if let securityQuestion = securityQuestion {
			out[key.securityQuestion.rawValue] = securityQuestion as AnyObject
		}
		if let securityAnswer = securityAnswer {
			out[key.securityAnswer.rawValue] = securityAnswer as AnyObject
		}

		return out
	}
}

func ==(lhs: UserData, rhs: UserData) -> Bool {
	return lhs.UID == rhs.UID && lhs.company == rhs.company && lhs.score == rhs.score && lhs.lastRated == rhs.lastRated && lhs.lastRatedDate == rhs.lastRatedDate && lhs.securityQuestion == rhs.securityQuestion && lhs.securityAnswer == rhs.securityAnswer
}
