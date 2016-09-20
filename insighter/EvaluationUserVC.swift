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

		userRatingLbl.rating = 10
		userRatingDiffLbl.setRatingDifference(1)

		fbScoreTotalLbl.text = "tot"
		fbRewardLbl.text = "reward"
		fbScoreThisLbl.text = "this"
		fbScoreLastLbl.text = "last"
		fbScorePrevLbl.text = "prev"
		fbScoreSumLbl.text = "sum"
	}
}
