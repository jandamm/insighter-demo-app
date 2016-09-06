//
//  JDAppCoordinatorDelegate.swift
//  insighter
//
//  Created by Jan Dammshäuser on 30.08.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import JDCoordinator

typealias JDAppCoordinatorDelegate = protocol<JDOnboardingCoordinatorDelegate, JDLoginCoordinatorDelegate, JDQuestionCoordinatorDelegate, JDEvaluationCoordinatorDelegate>

protocol JDOnboardingCoordinatorDelegate: JDCoordinatorDelegate {
    func onboardingEnded(finishedCoordinator: JDCoordinator)
}

protocol JDLoginCoordinatorDelegate: JDCoordinatorDelegate {
    func loginEnded(finishedCoordinator: JDCoordinator)
}

protocol JDQuestionCoordinatorDelegate: JDCoordinatorDelegate {
    func questionsAsked(finishedCoordinator: JDCoordinator)
}

protocol JDEvaluationCoordinatorDelegate: JDCoordinatorDelegate {
    func loggedOut(finishedCoordinator: JDCoordinator)
}
