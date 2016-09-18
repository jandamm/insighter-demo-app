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

@IBDesignable
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
