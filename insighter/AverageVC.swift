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

	// MARK: - Global Methods

	func setAverage(_ average: Average) {
		self.average = average

		setupDataFields()

		ratingBar.setAverage(average)
	}

	// MARK: - Private Methods

	private func setupDataFields() {
		// TODO: - Implement

		userScoreLbl.text = "8,0"
		compScoreLbl.text = "7,0"
		weekLbl.text = "KW 12"

		print("Setup Data Fields")
	}
}
