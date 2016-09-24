//
//  Average.swift
//  insighter
//
//  Created by Jan Dammshäuser on 18.09.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import UIKit

struct Average: Equatable {
	let key: String
	let company: Company?
	let user: User?

	func diff(to lastWeek: Average?) -> (user: Double?, company: Double?) {
		let company = self.company?.diff(to: lastWeek?.company)
		let user = self.user?.diff(to: lastWeek?.user)
		return (user, company)
	}

	var week: String {
		let kw = key.components(separatedBy: "-")

		let userKey = user?.key ?? key
		let compKey = company?.key ?? key

		guard key == compKey, key == userKey else {
			return "Error"
		}

		guard kw.count == 2 else {
			return "KW --"
		}

		return "KW \(kw[1])"
	}

	struct Company: Equatable {
		let key: String
		let answeredQuestions: Int
		let sum: Int

		fileprivate func diff(to lastWeek: Company?) -> Double? {
			guard let lastWeek = lastWeek else {
				return nil
			}

			return averageDiff - lastWeek.averageDiff
		}

		private var averageDiff: Double {
			return Double(sum) / Double(answeredQuestions)
		}

		var averageBase: Double {
			let mltp = 10.0
			return (averageDiff * mltp).rounded() / mltp
		}

		var avg: CGFloat {
			return CGFloat(averageBase)
		}

		var average: String {
			return averageBase.asRating
		}
	}

	struct User: Equatable {
		let key: String
		let answers: [String: Int]

		func diff(to lastWeek: User?) -> Double? {
			guard let lastWeek = lastWeek else {
				return nil
			}
			return averageDiff - lastWeek.averageDiff
		}

		private var averageDiff: Double {
			var sum = 0

			for (_, rating) in answers {
				sum += rating
			}

			return Double(sum) / Double(answers.count)
		}

		var averageBase: Double {
			let mltp = 10.0
			return (averageDiff * mltp).rounded() / mltp
		}

		var avg: CGFloat {
			return CGFloat(averageBase)
		}

		var average: String {
			return averageBase.asRating
		}
	}
}

func ==(lhs: Average, rhs: Average) -> Bool {
	return lhs.key == rhs.key && lhs.company == rhs.company && lhs.user == rhs.user
}

func ==(lhs: Average.Company, rhs: Average.Company) -> Bool {
	return lhs.key == rhs.key && lhs.sum == rhs.sum && lhs.answeredQuestions == rhs.answeredQuestions
}

func ==(lhs: Average.User, rhs: Average.User) -> Bool {
	return lhs.key == rhs.key && lhs.answers == rhs.answers
}
