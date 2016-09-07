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

	private var _remoteConfigKeyDefault: String!

	// MARK: - Global Data

	var remoteConfigKeyDefault: String! {
		return _remoteConfigKeyDefault
	}

	// MARK: - Startup

	override func layoutSubviews() {
		super.layoutSubviews()

		styleView()
	}

	// MARK: - Interface Builder

	override func prepareForInterfaceBuilder() {
		super.prepareForInterfaceBuilder()

		applyTextStyle()
	}

	// MARK: - Appearance

	private func styleView() {
		if fontStyle == nil {
			applyTextStyle()
		}

		adjustsFontSizeToFitWidth = true
		minimumScaleFactor = 0.5
	}
}
