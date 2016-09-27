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

	private static func multiplier(forDate ti: TimeInterval) -> Int {
		let weeks = (-Date(timeIntervalSince1970: ti).timeIntervalSinceNow / 7 / 24 / 60 / 60).rounded(.down)
		let multiplier = pow(2, weeks)
		return Int(multiplier)
	}

	static let this = LastRated(rawValue: 1)
	static let last = LastRated(rawValue: 2)
	static let prev = LastRated(rawValue: 4)
}
