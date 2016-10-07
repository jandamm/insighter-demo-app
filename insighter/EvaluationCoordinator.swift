//
//  JDEvaluationCoordinator.swift
//  insighter
//
//  Created by Jan Dammshäuser on 30.08.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import JDCoordinator

protocol EvaluationDelegate: JDCoordinatorDelegate {
	func logout()
}

class EvaluationCoordinator: JDCoordinator, EvaluationDelegate {

	weak var delegate: EvaluationCoordinatorDelegate?

	// MARK: - Coordinator

	override func start() {
		NotificationService.shared.setupNotifications()

		showEvaluationVC()
	}

	// MARK: - Show Methods

	fileprivate func showEvaluationVC() {
		let vc = EvaluationVC()

		vc.delegate = self

		setViewControllers(vc, animated: true)
	}

	func logout() {
		delegate?.loggedOut(self)
	}
}
