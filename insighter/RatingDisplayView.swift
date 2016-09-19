//
//  RatingDisplayView.swift
//  insighter
//
//  Created by Jan Dammshäuser on 19.09.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import UIKit

// @IBDesignable
class RatingDisplayView: UIView {

	@IBInspectable var fontStyle: String! {
		didSet {
			ratingLbl?.fontStyle = fontStyle
		}
	}

	private weak var ratingLbl: JDLabel!
	private weak var ratingMaxLbl: JDLabel!

	private var rating: String?

	override func awakeFromNib() {
		super.awakeFromNib()

		addLabels()
		formatLabels()
	}

	private func addLabels() {
		let rating = JDLabel()
		let ratingMax = JDLabel()

		let ratingWidth = 87

		rating.frame = CGRect(x: 0, y: 0, width: ratingWidth, height: 72)
		ratingMax.frame = CGRect(x: ratingWidth, y: 32, width: 35, height: 30)

		addSubview(rating)
		addSubview(ratingMax)

		ratingLbl = rating
		ratingMaxLbl = ratingMax
	}

	private func formatLabels() {
		ratingLbl.fontStyle = fontStyle
		ratingLbl.textAlignment = .right
		ratingLbl.text = rating ?? "---"

		ratingMaxLbl.fontStyle = TextStyle.TextBig.rawValue
		ratingMaxLbl.text = "/\(RemoteConfig.shared.getDoubleAsString(forKey: .Max_Points))"
	}
}
