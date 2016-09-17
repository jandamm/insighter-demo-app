//
//  IntroVC.swift
//  insighter
//
//  Created by Jan Dammshäuser on 21.05.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import UIKit
import Firebase

class IntroVC: UIViewController {

	var animated = true

	// MARK: - Outlets

	@IBOutlet weak var logoVerticalCenterConstraint: NSLayoutConstraint!
	@IBOutlet weak var loadingSpinnerView: LoadingView!

	// MARK: - Startup

	override func viewDidLoad() {
		super.viewDidLoad()

		if !self.animated {
			setupScreen()
			applyScreen()
		}
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)

		spinnerStart()

		if self.animated {
			introAnimationStart()
		}
	}

	// MARK: - Animation

	fileprivate func introAnimationStart() {
		setupScreen()

		UIView.animate(withDuration: 0.5, animations: {
			self.applyScreen()
		})
	}

	fileprivate func setupScreen() {
		loadingSpinnerView.alpha = 0
		logoVerticalCenterConstraint.constant = -45
	}

	fileprivate func applyScreen() {
		self.view.layoutIfNeeded()
		self.loadingSpinnerView.alpha = 1
	}

	fileprivate func spinnerStart() {
		loadingSpinnerView.animationStart()
	}
}
