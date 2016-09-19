//
//  JDOnboardingCoordinator.swift
//  insighter
//
//  Created by Jan Dammshäuser on 30.08.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import JDCoordinator

protocol OnboardingDelegate: JDCoordinatorDelegate {
	func welcomeBtnPressed()
	func notifBtnPressed()
}

class OnboardingCoordinator: JDCoordinator, FIRLoginable, OnboardingDelegate {

	weak var delegate: OnboardingCoordinatorDelegate?

	// MARK: - Coordinator

	override func start() {
		showOnboardingWelcome()
	}

	// MARK: - Delegates

	func welcomeBtnPressed() {
		let showNotification = NotificationService.shared.hasNoAllowance()

		if showNotification {
			showOnboardingNotification()
		} else {
			onboardingEnded()
		}
	}

	func notifBtnPressed() {
		NotificationService.shared.askForAllowance()

		onboardingEnded()
	}

	// MARK: - Private Methods

	fileprivate func onboardingEnded() {
		delegate?.onboardingEnded(self)
	}

	// MARK: - Show Methods

	fileprivate func showOnboardingWelcome() {
		let vc = OnboardingWelcomeVC()

		vc.delegate = self

		pushViewController(vc, animated: true)
	}

	fileprivate func showOnboardingNotification() {
		let vc = OnboardingNotificationVC()

		vc.delegate = self

		pushViewController(vc, animated: true)
	}
}
