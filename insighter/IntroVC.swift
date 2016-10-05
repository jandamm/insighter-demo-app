//
//  IntroVC.swift
//  insighter
//
//  Created by Jan Dammshäuser on 21.05.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import UIKit
import Firebase
import JDCoordinator

protocol IntroDelegate: JDCoordinatorDelegate {
	func cancelStartup()
}

class IntroVC: UIViewController {

	var animated = true

	weak var delegate: IntroDelegate?

	// MARK: - Outlets

	@IBOutlet weak var introView: IntroAnimationView!
	@IBOutlet weak var cancelView: UIStackView!

	// MARK: - Startup

	override func viewDidLoad() {
		super.viewDidLoad()

		if animated {
			introView.addIntroViewAnimation()
		}

		setupCancelView()
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)

		if self.animated {
			introView.removeIntroViewAnimation()

			introAnimation()
		} else {
			loadingAnimation()
		}
	}

	// MARK: - Actions

	@IBAction func cancelBtn(sender: UIButton) {
		delegate?.cancelStartup()
	}

	private func introAnimation(withLoadingAnimation loading: Bool = true) {
		introView.addIntroAnimation(removedOnCompletion: true) { [weak self] _ in
			if loading {
				self?.loadingAnimation()
			}
		}
	}

	private func loadingAnimation() {
		introView.addLoadingAnimation()
	}

	private func setupCancelView() {
		cancelView.isHidden = true

		DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
			self?.cancelView.alpha = 0
			self?.cancelView.isHidden = false

			UIView.animate(withDuration: 0.5, animations: { [weak self] in
				self?.cancelView.alpha = 1
			})
		}
	}
}
