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

		userRatingLbl.rating = 6.8
		userRatingDiffLbl.setRatingDifference(-0.3)

		compRatingLbl.rating = 6.7
		compRatingDiffLbl.setRatingDifference(0.2)

		addAverage(Average(key: "2016-27", company: Average.Company(key: "2016-27", answeredQuestions: 5, sum: 31), user: Average.User(key: "2016-27", answers: ["1": 56, "2": 0, "3": 0, "4": 0, "5": 0, "6": 0, "7": 0, "8": 0, "9": 0, "0": 0])))

		addAverage(Average(key: "2016-28", company: Average.Company(key: "2016-28", answeredQuestions: 10, sum: 61), user: Average.User(key: "2016-28", answers: ["1": 50, "2": 0, "3": 0, "4": 0, "5": 0, "6": 0, "7": 0, "8": 0, "9": 0, "0": 0])))

		addAverage(Average(key: "2016-29", company: Average.Company(key: "2016-29", answeredQuestions: 10, sum: 62), user: Average.User(key: "2016-29", answers: ["1": 62, "2": 0, "3": 0, "4": 0, "5": 0, "6": 0, "7": 0, "8": 0, "9": 0, "0": 0])))

		addAverage(Average(key: "2016-30", company: Average.Company(key: "2016-30", answeredQuestions: 10, sum: 65), user: Average.User(key: "2016-30", answers: ["1": 71, "2": 0, "3": 0, "4": 0, "5": 0, "6": 0, "7": 0, "8": 0, "9": 0, "0": 0])))

		addAverage(Average(key: "2016-31", company: Average.Company(key: "2016-31", answeredQuestions: 10, sum: 67), user: Average.User(key: "2016-31", answers: ["1": 68, "2": 0, "3": 0, "4": 0, "5": 0, "6": 0, "7": 0, "8": 0, "9": 0, "0": 0])))
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
