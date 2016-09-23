//
//  EvaluationUserVC.swift
//  insighter
//
//  Created by Jan Dammshäuser on 14.08.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import UIKit

class EvaluationUserVC: UIViewController {

	// MARK: - Outlets

	@IBOutlet weak var userRatingLbl: RatingDisplayView!
	@IBOutlet weak var userRatingDiffLbl: JDRatingLabel!
	@IBOutlet weak var fbScoreTotalLbl: JDLabel!
	@IBOutlet weak var fbRewardLbl: JDLabel!
	@IBOutlet weak var fbScoreThisLbl: JDLabel!
	@IBOutlet weak var fbScoreLastView: UIStackView!
	@IBOutlet weak var fbScoreLastLbl: JDLabel!
	@IBOutlet weak var fbScorePrevView: UIStackView!
	@IBOutlet weak var fbScorePrevLbl: JDLabel!
	@IBOutlet weak var fbScoreSumLbl: JDLabel!

	// MARK: - Startup

	override func viewDidLoad() {
		super.viewDidLoad()

		setUserRating()
		setUserScore()
		setScoreSums()
	}

	// MARK: - Private Methods

	private func setUserRating() {
		let thisRating = DataService.shared.userRating
		let lastRating = DataService.shared.averages.last?.user

		let ratingDiff = thisRating?.diff(to: lastRating)

		userRatingLbl.rating = thisRating?.averageBase
		userRatingDiffLbl.setRatingDifference(ratingDiff)
	}

	private func setUserScore() {
		fbScoreTotalLbl.text = UserLoginService.shared.user?.scoreString

		if let reward = UserLoginService.shared.company?.goodie {
			fbRewardLbl.text = reward
		} else {
			fbRewardLbl.isHidden = true
		}
	}

	private func setScoreSums() {
		fbScoreThisLbl.text = "100"
		fbScoreLastLbl.text = "50"
		fbScorePrevLbl.text = "25"
		fbScoreSumLbl.text = "+175"
	}
}
