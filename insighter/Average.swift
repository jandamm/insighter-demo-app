//
//  Average.swift
//  insighter
//
//  Created by Jan Dammshäuser on 18.09.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import Foundation

struct Average {
	let key: String
	let company: CompanyAverage
	let user: UserAverage

	var week: String {
		let kw = key.components(separatedBy: "-")

		guard key == company.key, key == user.key else {
			return "Error"
		}

		guard kw.count == 2 else {
			return "KW --"
		}

		return "KW \(kw[1])"
	}
}

struct CompanyAverage {
	let key: String
	let users: Int
	let sum: Int

	var avg: Double {
		let avg = Double(sum) / Double(users)
		let mltp = 10.0
		return (avg * mltp).rounded() / mltp
	}

	var average: String {
		return String(avg)
	}
}

struct UserAverage {
	let key: String
	let answers: [String: Int]

	var avg: Double {
		var sum = 0

		for (_, rating) in answers {
			sum += rating
		}

		return Double(sum) / Double(answers.count)
	}

	var average: String {
		return String(avg)
	}
}
