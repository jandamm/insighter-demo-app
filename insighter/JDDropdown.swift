//
//  JDDropdown.swift
//  insighter
//
//  Created by Jan Dammshäuser on 10.08.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import UIKit
import DropDown

// @IBDesignable
class JDDropdown: JDLabel, Touchable {

	// MARK: - Design

	private var dropDown: DropDown?
	private weak var imgView: UIImageView?

	// MARK: - Private Data

	private var dropdownShown = false {
		didSet {
			rotateArrow()

			if dropdownShown {
				dropDown?.show()
			}
		}
	}

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

	override func didMoveToSuperview() {
		super.didMoveToSuperview()

		styleView()
	}

	override func prepareForInterfaceBuilder() {
		super.prepareForInterfaceBuilder()

		applyTextStyle()
	}

	// MARK: - User Interaction

	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		guard let _ = touches.first else {
			return
		}

		toggleDropdown()
	}

	// MARK: - Appearance

	private func styleView() {
		if fontStyle == nil {
			applyTextStyle()
		}

		isUserInteractionEnabled = true
	}

	// MARK: - Internal Methods

	func setDataSource(_ source: [String]) {
		_dropdownList = source
		removeImageView()

		if source.count == 1 {
			_selection = source.first
		} else {
			addImageView()
			setupOrUpdateDropdown()
		}
	}

	// MARK: - Private Methods

	private func toggleDropdown() {
		dropdownShown = !dropdownShown
	}

	private func updateDropdown() {
		guard let dropDown = dropDown, let dropdownList = _dropdownList else {
			return
		}

		dropDown.dataSource = dropdownList
		dropDown.reloadAllComponents()
	}

	private func setupOrUpdateDropdown() {
		guard self.dropDown == nil else {
			return updateDropdown()
		}

		let dropDown = DropDown()
		let dropdownList = _dropdownList ?? [""]

		dropDown.anchorView = self
		dropDown.direction = .any

		dropDown.dataSource = dropdownList

		dropDown.textFont = TextStyle.TextSmall.font()
		dropDown.textColor = TextStyle.TextSmall.color()
		dropDown.backgroundColor = Colors.white
		dropDown.selectionBackgroundColor = Colors.lightContrast
		dropDown.bottomOffset = CGPoint(x: 0, y: (dropDown.anchorView?.plainView.bounds.height)!)
		dropDown.topOffset = CGPoint(x: 0, y: -(dropDown.anchorView?.plainView.bounds.height)!)

		dropDown.shadowColor = UIColor.white.withAlphaComponent(0)

		dropDown.selectionAction = { [weak self](_, item: String) in
			self?._selection = item
			self?.toggleDropdown()
		}
		dropDown.cancelAction = { [weak self] in
			self?.toggleDropdown()
		}

		self.dropDown = dropDown
	}

	private func rotateArrow() {
		guard let imgView = imgView else {
			return
		}

		let scaleY: CGFloat = dropdownShown ? -1 : 1

		UIView.animate(withDuration: 0.2) {
			imgView.transform = CGAffineTransform(scaleX: 1, y: scaleY)
		}
	}

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
