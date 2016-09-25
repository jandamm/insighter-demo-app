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

	// MARK: - Startup

	override func viewDidLoad() {
		super.viewDidLoad()

		setRatings()
		addAverages()
	}

	// MARK: - Private Methods

	private func addAverages() {
		var averages = DataService.shared.averages

		if averages.count == 0 {
			averages.append(Average(key: "", company: nil, user: nil))
		}

		for average in averages {
			addAverage(average)
		}
	}

	private func setRatings() {
		let averages = DataService.shared.averages
		let count = averages.count - 1

		let thisRating: Average?
		let lastRating: Average?

		if count < 0 {
			thisRating = nil
			lastRating = nil
		} else {
			thisRating = averages[count]
			lastRating = count == 0 ? nil : averages[count - 1]
		}

		let ratingDiff = thisRating?.diff(to: lastRating)

		userRatingLbl.rating = thisRating?.user?.averageBase
		userRatingDiffLbl.setRatingDifference(ratingDiff?.user)

		compRatingLbl.rating = thisRating?.company?.averageBase
		compRatingDiffLbl.setRatingDifference(ratingDiff?.company)
	}

	private func addAverage(_ average: Average) {
		let bar = AverageVC()

		bar.setAverage(average)

		addChildViewController(bar)
		averageView.addArrangedSubview(bar.view)
		bar.didMove(toParentViewController: self)
	}
}
