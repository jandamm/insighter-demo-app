//
//  JDButton.swift
//  insighter
//
//  Created by Jan Dammshäuser on 09.08.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import UIKit

// @IBDesignable
class JDButton: UIButton, TextStylable, TextResettable {

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
	@IBInspectable var overrideDefaultSettings: Bool!

	// MARK: - Private Data

	fileprivate var _remoteConfigKeyDefault: String!

	// MARK: - Global Data

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
	}
}
