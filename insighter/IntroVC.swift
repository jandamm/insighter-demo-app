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

		introView.addIntroViewAnimation(removedOnCompletion: false)
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)

		introView.removeIntroViewAnimation()

		introView.addIntroAnimation(removedOnCompletion: true) { [weak self] finished in
			self?.introView.addLoadingAnimation()
		}
	}
}
