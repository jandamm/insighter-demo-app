//
//  LoadingView.swift
//  insighter
//
//  Created by Jan Dammshäuser on 08.08.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import UIKit

// @IBDesignable
class LoadingView: UIView {

	// MARK: - Variables

	fileprivate var _boundsMax: CGRect!
	fileprivate var _boundsMin: CGRect!

	// MARK: - Startup

	override func layoutSubviews() {
		super.layoutSubviews()

		layoutView()
	}

	// MARK: - Interface Builder

	override func prepareForInterfaceBuilder() {
		super.prepareForInterfaceBuilder()

		layoutView()
	}

	// MARK: - Internal Methods

	func animationStart() {
		let width = bounds.width
		let widthMin = width * 0.25
		let inset = (width - widthMin) / 2

		_boundsMax = CGRect(x: 0, y: 0, width: width, height: width)
		_boundsMin = CGRect(x: inset, y: inset, width: widthMin, height: widthMin)

		animation()
	}

	// MARK: - Animation

	fileprivate func animation() {
		UIView.animate(withDuration: 1, animations: { [weak self] in
			if let view = self {
				view.bounds = view.bounds == view._boundsMax ? view._boundsMin : view._boundsMax
			}
		}, completion: { [weak self] _ in
			self?.animation()
		})
	}

	// MARK: - Layout

	fileprivate func layoutView() {
		layer.cornerRadius = bounds.width / 2
	}
}
