//
//  RatingColors.swift
//  insighter
//
//  Created by Jan Dammshäuser on 15.08.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import UIKit

class RatingColors: ColorScheme {

	class func color(forRating rating: Int?) -> UIColor {
		guard let rating = rating else {
			return null
		}

		switch rating {
		case let y where y <= 0: return zero
		case 1: return one
		case 2: return two
		case 3: return three
		case 4: return four
		case 5: return five
		case 6: return six
		case 7: return seven
		case 8: return eight
		case 9: return nine
		default: return ten
		}
	}

	private class var null: UIColor {
		return Colors.highlight
	}

	private class var zero: UIColor {
		return Colors.error
	}

	private class var one: UIColor {
		return rgba(246, 97, 97, 1)
	}

	private class var two: UIColor {
		return rgba(248, 114, 76, 1)
	}

	private class var three: UIColor {
		return rgba(250, 132, 73, 1)
	}

	private class var four: UIColor {
		return rgba(252, 149, 70, 1)
	}

	private class var five: UIColor {
		return Colors.highlight
	}

	private class var six: UIColor {
		return rgba(222, 170, 77, 1)
	}

	private class var seven: UIColor {
		return rgba(189, 174, 86, 1)
	}

	private class var eight: UIColor {
		return rgba(157, 178, 96, 1)
	}

	private class var nine: UIColor {
		return rgba(124, 182, 105, 1)
	}

	private class var ten: UIColor {
		return Colors.success
	}
}
