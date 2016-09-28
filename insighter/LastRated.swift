//
//  LastRated.swift
//  insighter
//
//  Created by Jan Dammshäuser on 27.09.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import Foundation

struct LastRated: OptionSet {
	let rawValue: Int
	let realValue: Int

	init(rawValue: Int) {
		self.realValue = rawValue
		self.rawValue = rawValue
	}

	init(realValue: Int?, relationDate ti: TimeInterval?) {
		guard let realValue = realValue, let ti = ti, ti > 0 else {
			self.realValue = 0
			self.rawValue = 0
			return
		}

		self.realValue = realValue
		self.rawValue = realValue * LastRated.multiplier(forDate: ti)
	}

	func ratingScore(forWeek week: LastRated = [.this, .last, .prev]) -> Double {
		var score: Double = 0

		if self.contains(.this) && week.contains(.this) {
			score += RemoteConfig.shared.getDouble(forKey: .Score_This_Week)
		}
		if self.contains(.last) && week.contains(.last) {
			score += RemoteConfig.shared.getDouble(forKey: .Score_Last_Week)
		}
		if self.contains(.prev) && week.contains(.prev) {
			score += RemoteConfig.shared.getDouble(forKey: .Score_Prev_Week)
		}

		return score
	}

	func ratingScore(forWeek week: LastRated = [.this, .last, .prev]) -> String {
		return ratingScore(forWeek: week).asScore
	}

	private static func multiplier(forDate ti: TimeInterval) -> Int {
		let weeks = (-Date(timeIntervalSince1970: ti).timeIntervalSinceNow / 7 / 24 / 60 / 60).rounded(.down)
		let multiplier = pow(2, weeks)
		return Int(multiplier)
	}

	static let this = LastRated(rawValue: 1)
	static let last = LastRated(rawValue: 2)
	static let prev = LastRated(rawValue: 4)
}
