//
//  JDLabel.swift
//  insighter
//
//  Created by Jan Dammshäuser on 09.08.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import UIKit

// @IBDesignable
class JDLabel: UILabel, TextStylable, TextResettable {

	// MARK: - Design

	@IBInspectable var remoteConfigKey: String! {
		didSet {
			if _remoteConfigKeyDefault == nil {
				_remoteConfigKeyDefault = remoteConfigKey
			}
			setText()
		}
	}
	@IBInspectable var fontStyle: String! {
		didSet {
			applyTextStyle()
		}
	}

	// MARK: - Private Data

	fileprivate var _remoteConfigKeyDefault: String!

	// MARK: - Internal Data

	var remoteConfigKeyDefault: String! {
		return _remoteConfigKeyDefault
	}

	// MARK: - Startup

	override func didMoveToSuperview() {
		super.didMoveToSuperview()

		styleView()
	}

	// MARK: - Interface Builder

	override func prepareForInterfaceBuilder() {
		super.prepareForInterfaceBuilder()

		applyTextStyle()
	}

	// MARK: - Appearance

	fileprivate func styleView() {
		if fontStyle == nil {
			applyTextStyle()
		}

		adjustsFontSizeToFitWidth = true
		minimumScaleFactor = 0.5
	}
}

// @IBDesignable
class JDDateLabel: JDLabel {

	// MARK: - Design

	@IBInspectable var thisWeek: Bool = true {
		didSet {
			setDate()
		}
	}

	// MARK: - Startup

	override func didMoveToSuperview() {
		super.didMoveToSuperview()

		setDate()
	}

	// MARK: - Private Methods

	private func setDate() {
		let adjustInterval: TimeInterval = thisWeek ? 0 : -7 * 24 * 60 * 60
		let date = Date().addingTimeInterval(adjustInterval)

		text = String(describing: date)
	}
}

// @IBDesignable
class JDRatingLabel: UILabel, TextStylable {

	var fontStyle: String! {
		didSet {
			applyTextStyle()
		}
	}

	// MARK: - Private Data

	private enum DiffType {
		case negative, positive, neutral

		init(rawValue: Double) {
			if rawValue > 0 {
				self = .positive
			} else if rawValue < 0 {
				self = .negative
			} else {
				self = .neutral
			}
		}

		var sign: String {
			switch self {
			case .negative: return ""
			case .positive: return "+"
			case .neutral: return "±"
			}
		}
	}

	private var diff: Double = 0.0
	private var diffType = DiffType(rawValue: 0.0)

	// MARK: - Internal Methods

	func setRatingDifference(_ diff: Double) {
		self.diff = diff
		self.diffType = DiffType(rawValue: diff)

		setFontStyle()
		setText()
	}

	// MARK: - Private Methods

	private func setFontStyle() {
		switch diffType {
		case .negative: fontStyle = TextStyle.RatingDiffError.rawValue
		case .positive: fontStyle = TextStyle.RatingDiffSuccess.rawValue
		case .neutral: fontStyle = TextStyle.RatingDiffMedium.rawValue
		}
	}

	private func setText() {
		text = "\(diffType.sign)\(diff.asRatingDiff)"
	}
}
