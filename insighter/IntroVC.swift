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

	@IBOutlet weak var introView: IntroAnimationView!

	// MARK: - Startup

	override func viewDidLoad() {
		super.viewDidLoad()

		if animated {
			introView.addIntroViewAnimation()
		}
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
}
