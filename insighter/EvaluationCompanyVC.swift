//
//  EvaluationCompanyVC.swift
//  insighter
//
//  Created by Jan Dammshäuser on 14.08.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import UIKit

class EvaluationCompanyVC: UIViewController {

	// MARK: - Outlets

	@IBOutlet weak var averageView: UIStackView!
	@IBOutlet weak var userRatingLbl: RatingDisplayView!
	@IBOutlet weak var compRatingLbl: RatingDisplayView!
	@IBOutlet weak var userRatingDiffLbl: JDRatingLabel!
	@IBOutlet weak var compRatingDiffLbl: JDRatingLabel!

	// MARK: - Private Data

	// MARK: - Startup

	override func viewDidLoad() {
		super.viewDidLoad()

		userRatingLbl.rating = 10
		userRatingDiffLbl.setRatingDifference(1)

		compRatingLbl.rating = 1
		compRatingDiffLbl.setRatingDifference(-1)
	}

	// MARK: - Internal Methods

	func addAverage(_ average: Average) {
		let bar = AverageVC()

		bar.setAverage(average)

		addChildViewController(bar)
		averageView.addArrangedSubview(bar.view)
		bar.didMove(toParentViewController: self)
	}
}
