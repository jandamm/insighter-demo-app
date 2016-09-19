//
//  Average.swift
//  insighter
//
//  Created by Jan Dammshäuser on 18.09.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import UIKit

struct Average {
	let key: String
	let company: Company
	let user: User

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

	struct Company {
		let key: String
		let users: Int
		let sum: Int

		private var averageBase: Double {
			let avg = Double(sum) / Double(users)
			let mltp = 10.0
			return (avg * mltp).rounded() / mltp
		}

		var avg: CGFloat {
			return CGFloat(averageBase)
		}

		var average: String {
			return String(averageBase)
		}
	}

	struct User {
		let key: String
		let answers: [String: Int]

		var averageBase: Double {
			var sum = 0

			for (_, rating) in answers {
				sum += rating
			}

			return Double(sum) / Double(answers.count)
		}

		var avg: CGFloat {
			return CGFloat(averageBase)
		}

		var average: String {
			return String(averageBase)
		}
	}
}
