//
//  JDDropdown.swift
//  insighter
//
//  Created by Jan Dammshäuser on 10.08.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import UIKit

// @IBDesignable
class JDDropdown: UILabel, TextStylable, TextRemoteConfigable {

	// MARK: - Design

	@IBInspectable var fontStyle: String! {
		didSet {
			applyTextStyle()
		}
	}
	@IBInspectable var remoteConfigKey: String! {
		didSet {
			setText()
		}
	}

	// MARK: - Private Data

	private var _dropdownList: [String]?
	private var _selection: String? {
		didSet {
			text = _selection
		}
	}

	// MARK: - External Data

	var selection: String? {
		return _selection
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
	}

	// MARK: - Global Methods

	func dataSource(source: [String]) {
		_dropdownList = source

		// TEST
		_selection = source.first

		if source.count == 1 {
			_selection = source.first
		}
	}

	// MARK: - Private Methods
}
