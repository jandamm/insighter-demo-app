//
//  IntExtension.swift
//  insighter
//
//  Created by Jan Dammshäuser on 16.08.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import Foundation

extension Int {

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

	func makeBetween(_ floor: Double, and ceiling: Double) -> Double {
		if self < floor {
			return floor
		} else if self > ceiling {
			return ceiling
		}

		return self
	}
}
