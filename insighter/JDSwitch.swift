//
//  JDSwitch.swift
//  insighter
//
//  Created by Jan Dammshäuser on 25.09.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import UIKit

// @IBDesignable
class JDSwitch: UISwitch {

	// MARK: - Design

	@IBInspectable var switchStyle: String! {
		didSet {
			applySwitchStyle()
		}
	}

	// MARK: - Startup

	override func awakeFromNib() {
		super.awakeFromNib()

		applySwitchStyle()
	}

	override func prepareForInterfaceBuilder() {
		super.prepareForInterfaceBuilder()

		applySwitchStyle()
	}

	// MARK: - Private Methods

	private func applySwitchStyle() {
		let style = getStyle()
		let color = style.color()

		tintColor = color
		onTintColor = color
		thumbTintColor = Colors.lightContrast
	}

	private func getStyle() -> SwitchStyle {
		guard let font = switchStyle, let style = SwitchStyle(rawValue: font) else {
			return SwitchStyle.Primary
		}

		return style
	}
}
