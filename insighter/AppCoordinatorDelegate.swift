//
//  JDAppCoordinatorDelegate.swift
//  insighter
//
//  Created by Jan Dammshäuser on 30.08.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import JDCoordinator

typealias AppCoordinatorDelegate = protocol<OnboardingCoordinatorDelegate, LoginCoordinatorDelegate, QuestionCoordinatorDelegate, EvaluationCoordinatorDelegate>

protocol OnboardingCoordinatorDelegate: JDCoordinatorDelegate {
	func onboardingEnded(finishedCoordinator: JDCoordinator)
}

protocol LoginCoordinatorDelegate: JDCoordinatorDelegate {
	func loginEnded(finishedCoordinator: JDCoordinator)
}

protocol QuestionCoordinatorDelegate: JDCoordinatorDelegate {
	func questionsAsked(finishedCoordinator: JDCoordinator)
}

protocol EvaluationCoordinatorDelegate: JDCoordinatorDelegate {
	func loggedOut(finishedCoordinator: JDCoordinator)
}
