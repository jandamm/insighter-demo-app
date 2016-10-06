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
	@IBOutlet weak var fbScoreImage: UIImageView!
	@IBOutlet weak var fbScoreTotalLbl: JDLabel!
	@IBOutlet weak var fbRewardLbl: JDLabel!
	@IBOutlet weak var fbScoreView: UIStackView!
	@IBOutlet weak var fbScoreThisLbl: JDLabel!
	@IBOutlet weak var fbScoreLastLbl: JDLabel!
	@IBOutlet weak var fbScorePrevLbl: JDLabel!
	@IBOutlet weak var fbScoreSumLbl: JDLabel!

	// MARK: - Startup

	override func viewDidLoad() {
		super.viewDidLoad()

		hideScoreImage()

		setUserRating()
		setUserScore()
		setScoreSums()
	}

	// MARK: - Private Methods

	private func hideScoreImage() {
		let smallPhone = UIScreen.main.bounds.width < 375

		fbScoreImage.isHidden = smallPhone
	}

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
		let lastRated = UserLoginService.shared.lastRated

		if lastRated.isDisjoint(with: [.this, .last, .prev]) {
			fbScoreView.isHidden = true
			return
		}

		fbScoreThisLbl.text = lastRated.ratingScore(forWeek: .this)
		fbScoreLastLbl.text = lastRated.ratingScore(forWeek: .last)
		fbScorePrevLbl.text = lastRated.ratingScore(forWeek: .prev)

		fbScoreSumLbl.text = lastRated.ratingScore()
	}
}
