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
	let score: Int?
	let ratedOne: CalendarWeek
	let ratedTwo: CalendarWeek
	let securityQuestion: String?
	let securityAnswer: String?

	var scoreString: String {
		guard let score = score else {
			return "0"
		}
		return "\(score)"
	}

	// MARK: - Initialization

	init(UID: String, company: String?, score: Int?, ratedOne: TimeInterval?, ratedTwo: TimeInterval?, securityQuestion: String?, securityAnswer: String?) {
		self.UID = UID
		self.company = company
		self.score = score
		self.securityAnswer = securityAnswer
		self.securityQuestion = securityQuestion

		let ratedOne = ratedOne ?? 0
		let ratedOneDate = Date(timeIntervalSince1970: ratedOne)
		self.ratedOne = CalendarWeek(withDate: ratedOneDate)

		let ratedTwo = ratedTwo ?? 0
		let ratedTwoDate = Date(timeIntervalSince1970: ratedTwo)
		self.ratedTwo = CalendarWeek(withDate: ratedTwoDate)
	}

	// MARK: - FIRUploadable

	var FIR_PATH: String {
		return "\(DBPathKeys.user.rawValue)/\(UID)"
	}

	var uploadData: [String: AnyObject] {
		let key = DBValueKeys.User.self
		var out = [String: AnyObject]()

		if let company = company {
			out[key.company.rawValue] = company as AnyObject?
		}
		if ratedOne.timeIntervalSince1970 > 0 {
			out[key.ratedOne.rawValue] = ratedOne.timeIntervalSince1970 as AnyObject
		}
		if ratedTwo.timeIntervalSince1970 > 0 {
			out[key.ratedTwo.rawValue] = ratedTwo.timeIntervalSince1970 as AnyObject
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
	return lhs.UID == rhs.UID && lhs.company == rhs.company && lhs.ratedOne == rhs.ratedOne && lhs.ratedTwo == rhs.ratedTwo && lhs.securityQuestion == rhs.securityQuestion && lhs.securityAnswer == rhs.securityAnswer
}
