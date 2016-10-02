//
//  JDTextField.swift
//  insighter
//
//  Created by Jan Dammshäuser on 10.08.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import UIKit
import NextResponderTextField

// @IBDesignable
class JDTextField: NextResponderTextField, TextStylable, TextRemoteConfigable, Shakeable {

	private var line: CALayer?

	// MARK: - Outlets

	@IBOutlet weak var NextResponder: UIControl? {
		didSet {
			super.nextResponderField = NextResponder
		}
	}

	// MARK: - Design

	@IBInspectable var remoteConfigKey: String! {
		didSet {
			setText()
		}
	}

	let fontStyle: String! = TextStyle.TextField.rawValue

	var replaceStrings: [String: String]? {
		didSet {
			setText()
		}
	}

	// MARK: - Startup

	override func didMoveToSuperview() {
		super.didMoveToSuperview()

		styleView()
	}

	override func layoutSubviews() {
		super.layoutSubviews()

		addLine()
	}

	// MARK: - Interface Builder

	override func prepareForInterfaceBuilder() {
		super.prepareForInterfaceBuilder()

		applyTextStyle()
	}

	// MARK: - Appearance

	override func textRect(forBounds bounds: CGRect) -> CGRect {
		return CGRect(x: bounds.origin.x + 12, y: bounds.origin.y + 4, width: bounds.width - 24, height: bounds.height - 4)
	}

	override func editingRect(forBounds bounds: CGRect) -> CGRect {
		return textRect(forBounds: bounds)
	}

	fileprivate func styleView() {
		applyTextStyle()

		minimumFontSize = 14
		adjustsFontSizeToFitWidth = true
		borderStyle = .none
		enablesReturnKeyAutomatically = true
	}

	fileprivate func addLine() {
		let lineWidth: CGFloat = 1
		let lineFrame = CGRect(x: 0, y: bounds.height - lineWidth, width: bounds.width, height: lineWidth)

		if let line = self.line {
			line.frame = lineFrame
		} else {
			let line = CALayer()

			line.borderColor = Colors.primary.cgColor
			line.frame = lineFrame
			line.borderWidth = lineWidth

			layer.masksToBounds = true
			layer.addSublayer(line)
		}
	}
}
