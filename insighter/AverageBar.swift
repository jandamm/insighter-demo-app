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

	// MARK: - Constraints

	private weak var userConstraint: NSLayoutConstraint?
	private weak var compConstraint: NSLayoutConstraint?

	// MARK: - Private Data

	private enum BarType {
		case user, company
	}

	private var average: Average!

	// MARK: - Startup

	override func didMoveToSuperview() {
		super.didMoveToSuperview()

		setupView()

		addBar(forType: .company)
		addBar(forType: .user)
	}

	override func prepareForInterfaceBuilder() {
		super.prepareForInterfaceBuilder()

		setupView()
	}

	// MARK: - Internal Methods

	func layout(andSetAverage average: Average? = nil) {
		if let average = average {
			self.average = average
		}

		setupAverageBar()
	}

	// MARK: - Private Methods

	private func setupAverageBar() {
		let maxPoints = RemoteConfig.shared.getDouble(forKey: .Max_Points)
		let heightPerPoint = frame.height / CGFloat(maxPoints)

		let userConst: CGFloat = average.user != nil ? heightPerPoint * average.user!.avg : 0
		let compConst: CGFloat = average.company != nil ? heightPerPoint * average.company!.avg : 19

		userConstraint?.constant = userConst
		compConstraint?.constant = compConst
	}

	private func setupView() {
		layer.cornerRadius = 2
		layer.borderColor = Colors.lightContrast.cgColor
		layer.borderWidth = 1
		layer.masksToBounds = true
	}

	private func addBar(forType type: BarType) {
		let bar = UIView()
		addSubview(bar)

		bar.translatesAutoresizingMaskIntoConstraints = false

		let horizontal = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[v]-0-|", options: .directionLeadingToTrailing, metrics: nil, views: ["v": bar])
		let top = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: bar, attribute: .top, multiplier: 1, constant: 50)
		let bottom: NSLayoutConstraint

		switch type {
		case .user:
			bottom = NSLayoutConstraint(item: bar, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 3)

			bar.backgroundColor = Colors.highlight
			userConstraint = top
		case .company:
			bottom = NSLayoutConstraint(item: bar, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)

			bar.backgroundColor = Colors.primary
			compConstraint = top
		}

		self.addConstraints(horizontal)
		self.addConstraint(top)
		self.addConstraint(bottom)
	}
}
