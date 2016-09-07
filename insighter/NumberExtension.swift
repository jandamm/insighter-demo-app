//
//  IntExtension.swift
//  insighter
//
//  Created by Jan Dammshäuser on 16.08.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import Foundation

extension Int {

	func makeBetween(floor: Int, and ceiling: Int) -> Int {
		if self < floor {
			return floor
		} else if self > ceiling {
			return ceiling
		}

		return self
	}
}

extension Double {

	func makeBetween(floor: Double, and ceiling: Double) -> Double {
		if self < floor {
			return floor
		} else if self > ceiling {
			return ceiling
		}

		return self
	}
}
