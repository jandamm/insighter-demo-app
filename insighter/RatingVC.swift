//
//  RatingView.swift
//  insighter
//
//  Created by Jan Dammshäuser on 14.08.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import UIKit

class RatingVC: UIViewController, RatingSliderDelegate {

	// MARK: - Outlets

	@IBOutlet weak var ratingLbl: JDLabel!
	@IBOutlet weak var ratingSlider: RatingSlider!
	@IBOutlet weak var explanationLeftLbl: JDLabel!
	@IBOutlet weak var explanationRightLbl: JDLabel!

	// MARK: - Startup

	override func viewDidLoad() {
		super.viewDidLoad()

		ratingSlider.delegate = self

		ratingSliderDidChange()
	}

	// MARK: - RatingSliderDelegate

	func ratingSliderDidStart() {
		animateExplanationLabels(hidden: false)
	}

	func ratingSliderDidEnd() {
		animateExplanationLabels(hidden: true)
	}

	func ratingSliderDidChange() {
		let rating = ratingSlider.value

		ratingLbl.text = rating.string
		ratingLbl.textColor = rating.color

		if let questionVC = parent as? QuestionVC {
			questionVC.stateButtonApply()
		}
	}

	// MARK: - Animation

	fileprivate func animateExplanationLabels(hidden: Bool) {
		let alpha: CGFloat = hidden ? 0 : 1
		UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: { [weak self] in
			self?.explanationLeftLbl.alpha = alpha
			self?.explanationRightLbl.alpha = alpha
		}, completion: nil)
	}
}
