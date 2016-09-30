//
//  EvaluationVC.swift
//  insighter
//
//  Created by Jan Dammshäuser on 09.08.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import UIKit
import Firebase

class EvaluationVC: UIViewController {

	weak var delegate: EvaluationDelegate?

	// MARK: - Outlets

	@IBOutlet weak var scrollView: JDPagingScrollView!
	@IBOutlet weak var swipeInView: SwipeInView!

	private var evalUserVC: EvaluationUserVC!
	private var evalCompVC: EvaluationCompanyVC!

	// MARK: - Private Data

	private var animTimer: Timer!

	// MARK: - Startup

	override func viewDidLoad() {
		super.viewDidLoad()

		setupScrollView()

		setAnimationTimer()
	}

	// MARK: - Actions

	@IBAction func logout(_ sender: UIButton) {
		UserLoginService.shared.signOutUser(nil)

		self.delegate?.logout()
	}

	// MARK: - Internal Methods

	func swipeInAnimation() {
		swipeInView.addSwipeToNextPageAnimation(removedOnCompletion: true)
	}

	// MARK: - Private Methods

	private func setAnimationTimer() {
		let interval: TimeInterval = 3

		if #available(iOS 10.0, *) {
			animTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true, block: { [weak self] _ in
				self?.swipeInView.addSwipeToNextPageAnimation(removedOnCompletion: true)
			})
		} else {
			animTimer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(swipeInAnimation), userInfo: nil, repeats: true)
		}
	}

	private func setupScrollView() {
		evalUserVC = EvaluationUserVC()
		evalCompVC = EvaluationCompanyVC()

		addChildViewController(evalUserVC)
		scrollView.addSubview(evalUserVC.view)
		evalUserVC.didMove(toParentViewController: self)

		addChildViewController(evalCompVC)
		scrollView.addSubview(evalCompVC.view)
		evalCompVC.didMove(toParentViewController: self)
	}
}
