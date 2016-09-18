//
//  JDTextView.swift
//  insighter
//
//  Created by Jan Dammshäuser on 15.08.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import UIKit

// @IBDesignable
class JDTextView: UITextView, UITextViewDelegate, TextStylable {

	private var border: CALayer?

	// MARK: - Design

	let fontStyle: String! = TextStyle.TextView.rawValue

	// MARK: - Startup

	override func didMoveToSuperview() {
		super.didMoveToSuperview()

		delegate = self

		styleView()
	}

	override func layoutSubviews() {
		super.layoutSubviews()

		addBorder()
	}

	// MARK: - Interface Builder

	override func prepareForInterfaceBuilder() {
		super.prepareForInterfaceBuilder()

		applyTextStyle()
	}

	// MARK: - Dismiss Keyboard

	func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
		if (text == "\n") {
			textView.resignFirstResponder()
			return false
		}
		return true
	}

	// MARK: - Appearance

	fileprivate func styleView() {

		applyTextStyle()

		textContainerInset.left = 8
		textContainerInset.right = 8
		textContainerInset.top = 8
		textContainerInset.bottom = 8

		returnKeyType = .done
	}

	fileprivate func addBorder() {
		let lineWidth: CGFloat = 1
		let borderFrame = CGRect(x: 0, y: 0, width: bounds.width - 1, height: bounds.height - 1)

		if let border = self.border {
			border.frame = borderFrame
		} else {
			let border = CALayer()

			border.borderColor = Colors.primary.cgColor
			border.frame = borderFrame
			border.borderWidth = lineWidth

			layer.masksToBounds = true
			layer.addSublayer(border)
		}
	}
}
