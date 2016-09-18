//
//  AverageBar.swift
//  insighter
//
//  Created by Jan Dammshäuser on 18.09.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import UIKit

@IBDesignable
class AverageBar: UIView {

	// MARK: - Startup

	override func didMoveToSuperview() {
		super.didMoveToSuperview()

		setupView()
	}

	override func prepareForInterfaceBuilder() {
		super.prepareForInterfaceBuilder()

		setupView()
	}

	// MARK: - Global Methods

	func setAverage(_ average: Average) {
	}

	// MARK: - Private Methods

	private func setupView() {
		layer.cornerRadius = 2
		layer.borderColor = Colors.lightContrast.cgColor
		layer.borderWidth = 1
		layer.masksToBounds = true
	}
}
