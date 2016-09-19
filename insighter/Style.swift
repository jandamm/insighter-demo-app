//
//  Style.swift
//  insighter
//
//  Created by Jan Dammshäuser on 09.08.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import UIKit

protocol ColorScheme {}

extension ColorScheme {

	static func rgba(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ a: CGFloat) -> UIColor {
		return UIColor(red: r / 255, green: g / 255, blue: b / 255, alpha: a)
	}
}

class Colors: ColorScheme {

	class var text: UIColor {
		return rgba(33, 33, 33, 1)
	}

	class var highlight: UIColor {
		return rgba(255, 166, 67, 1)
	}

	class var primary: UIColor {
		return rgba(0, 156, 223, 1)
	}

	class var error: UIColor {
		return rgba(244, 81, 83, 1)
	}

	class var success: UIColor {
		return rgba(92, 187, 115, 1)
	}

	class var lightContrast: UIColor {
		return rgba(224, 224, 224, 1)
	}
}

enum TextStyle: String {
	case RatingBigText, RatingBigHighlight
	case EvaluationPrimary, EvaluationHighlight
	case Heading, HeadingPrimary, HeadingHighlight
	case TextBig, TextBigHighlight
	case Text, TextPrimary
	case TextSmall
	case Button, ButtonPrimary, ButtonHighlight, ButtonError
	case TextField, TextFieldPrimary, TextFieldHighlight
	case TextView, TextViewMedium, TextViewMediumWhite
	case TextSubLine, TextSubLineMedium

	func font() -> UIFont {
		let selfString = self.rawValue
		var size: CGFloat = 20
		var name = "AvenirNext-Regular"

		if selfString.contains("RatingBigText") {
			size = 30
		} else if selfString.contains("RatingBig") {
			size = 70
		} else if selfString.contains("Evaluation") {
			size = 53
		} else if selfString.contains("Heading") {
			size = 25
		} else if selfString.contains("TextBig") {
			size = 22
		} else if selfString.contains("TextField") {
			size = 18
		} else if selfString.contains("TextSmall") {
			size = 16
		} else if selfString.contains("TextView") {
			size = 14
		} else if selfString.contains("TextSubLine") {
			size = 12
		}

		if selfString.contains("Primary") || selfString.contains("Highlight") || selfString.contains("Medium") || selfString.contains("Error") {
			name = "AvenirNext-Medium"
		}

		return UIFont(name: name, size: size)!
	}

	func color() -> UIColor {
		let color: UIColor

		if String(describing: self).contains("Primary") {
			color = Colors.primary
		} else if String(describing: self).contains("Highlight") {
			color = Colors.highlight
		} else if String(describing: self).contains("Error") {
			color = Colors.error
		} else if String(describing: self).contains("White") {
			color = UIColor.white
		} else {
			color = Colors.text
		}

		return color
	}
}
