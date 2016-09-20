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

		userRatingLbl.rating = 7.3
		userRatingDiffLbl.setRatingDifference(-0.5)

		fbScoreTotalLbl.text = "375"
		fbRewardLbl.text = "Der Mitarbeiter mit dem höchsten Feedback-Score am Ende eines Quartals bekommt ein Spa-Wochenende geschenkt."
		fbScoreThisLbl.text = "100"
		fbScoreLastLbl.text = "50"
		fbScorePrevLbl.text = "25"
		fbScoreSumLbl.text = "+175"
	}
}
