//
//  AverageView.swift
//  insighter
//
//  Created by Jan Dammshäuser on 18.09.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import UIKit

class AverageVC: UIViewController {

	// MARK: - Outlets

	@IBOutlet weak var userScoreLbl: JDLabel!
	@IBOutlet weak var compScoreLbl: JDLabel!
	@IBOutlet weak var weekLbl: JDLabel!
	@IBOutlet weak var ratingBar: AverageBar!

	// MARK: - Private Data

	private var average: Average!

	override func awakeFromNib() {
		super.awakeFromNib()

		setupDataFields()

		ratingBar.setAverage(average)
	}

	// MARK: - Global Methods

	func setAverage(_ average: Average) {
		self.average = average
	}

	// MARK: - Private Methods

	private func setupDataFields() {
		// TODO: - Implement

		print("Setup Data Fields")
	}
}
