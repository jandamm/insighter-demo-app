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
	@IBOutlet weak var userRating: RatingDisplayView!
	@IBOutlet weak var compRating: RatingDisplayView!
	@IBOutlet weak var userRatingDiff: JDRatingLabel!
	@IBOutlet weak var compRatingDiff: JDRatingLabel!

	// MARK: - Private Data

	// MARK: - Startup

	override func viewDidLoad() {
		super.viewDidLoad()

		userRating.rating = 10
		userRatingDiff.setRatingDifference(1)

		compRating.rating = 1
		compRatingDiff.setRatingDifference(-1)
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
