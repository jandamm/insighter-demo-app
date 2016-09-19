//
//  IntExtension.swift
//  insighter
//
//  Created by Jan Dammshäuser on 16.08.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import Foundation

extension Int {

	var asRating: String {
		let number = NSNumber(value: self)
		return number.asRating
	}

	func makeBetween(_ floor: Int, and ceiling: Int) -> Int {
		if self < floor {
			return floor
		} else if self > ceiling {
			return ceiling
		}

		return self
	}
}

extension Double {

	var asRating: String {
		let number = NSNumber(value: self)
		return number.asRating
	}

	func makeBetween(_ floor: Double, and ceiling: Double) -> Double {
		if self < floor {
			return floor
		} else if self > ceiling {
			return ceiling
		}

		return self
	}
}

extension NSNumber {

	var asRating: String {
		let nf = getFormatter(forNumber: self)

		return nf.string(from: self) ?? String(describing: self)
	}

	private func getFormatter(forNumber number: NSNumber) -> NumberFormatter {
		let nf = NumberFormatter()

		nf.minimumIntegerDigits = 1
		nf.maximumIntegerDigits = 2
		nf.minimumFractionDigits = 1
		nf.maximumFractionDigits = number.doubleValue >= 10.0 ? 0 : 1

		return nf
	}
}
