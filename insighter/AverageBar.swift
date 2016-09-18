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

	// MARK: - Private Data

	private var average: Average!

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
		self.average = average

		setupDataFields()
		setupAverageBar()
	}

	// MARK: - Private Methods

	private func setupDataFields() {
		// TODO: - Implement

		print("Setup Data Fields")
	}

	private func setupAverageBar() {
		// TODO: - Implement

		print("Setup Average Bar")
	}

	private func setupView() {
		layer.cornerRadius = 2
		layer.borderColor = Colors.lightContrast.cgColor
		layer.borderWidth = 1
		layer.masksToBounds = true
	}
}
