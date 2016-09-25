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

	weak var imgView: UIImageView?

	var replaceStrings: [String: String]?

	// MARK: - Private Data

	fileprivate var _dropdownList: [String]?
	fileprivate var _selection: String? {
		didSet {
			text = _selection
		}
	}

	// MARK: - External Data

	var selection: String? {
		return _selection
	}

	// MARK: - Startup

	override func didMoveToSuperview() {
		super.didMoveToSuperview()

		styleView()
		addImageView()
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

	// MARK: - Internal Methods

	func dataSource(_ source: [String]) {
		_dropdownList = source

		// TEST
		_selection = source.first

		if source.count == 1 {
			_selection = source.first
		}
	}

	// MARK: - Private Methods

	private func addImageView() {
		let imgView = UIImageView()

		self.imgView = imgView

		imgView.image = #imageLiteral(resourceName: "dropdown-arrow")
		addSubview(imgView)

		imgView.translatesAutoresizingMaskIntoConstraints = false

		let views = ["v": imgView]
		let horizontal = NSLayoutConstraint.constraints(withVisualFormat: "H:[v(13)]-8-|", options: .directionLeadingToTrailing, metrics: nil, views: views)
		let vertical = NSLayoutConstraint.constraints(withVisualFormat: "V:|-9-[v(8)]", options: .directionLeadingToTrailing, metrics: nil, views: views)

		addConstraints(horizontal)
		addConstraints(vertical)
	}

	private func removeImageView() {
		imgView?.removeFromSuperview()
		imgView = nil
	}
}
