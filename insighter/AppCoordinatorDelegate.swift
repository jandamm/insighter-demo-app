//
//  JDAppCoordinatorDelegate.swift
//  insighter
//
//  Created by Jan Dammshäuser on 30.08.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import JDCoordinator

typealias AppCoordinatorDelegate = OnboardingCoordinatorDelegate & LoginCoordinatorDelegate & QuestionCoordinatorDelegate & EvaluationCoordinatorDelegate

protocol OnboardingCoordinatorDelegate: JDCoordinatorDelegate {
	func onboardingEnded(_ finishedCoordinator: JDCoordinator)
}

protocol LoginCoordinatorDelegate: JDCoordinatorDelegate {
	func loginEnded(_ finishedCoordinator: JDCoordinator)
}

protocol QuestionCoordinatorDelegate: JDCoordinatorDelegate {
	func questionsAsked(_ finishedCoordinator: JDCoordinator)
}

protocol EvaluationCoordinatorDelegate: JDCoordinatorDelegate {
	func loggedOut(_ finishedCoordinator: JDCoordinator)
}
