//
//  JDAppCoordinator.swift
//  insighter
//
//  Created by Jan Dammshäuser on 30.08.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import JDCoordinator

class AppCoordinator: JDParentCoordinator, AppCoordinatorDelegate {

	fileprivate var _userLoggedIn = false

	// MARK: - Coordinator

	override func start() {
		getInitialDataWithIntro(userDataOnly: false, animatedIntro: true)
	}

	// MARK: - Delegates

	func loggedOut(_ finishedCoordinator: JDCoordinator) {
		removeChildCoordinator(finishedCoordinator)

		showLogin()
	}

	func onboardingEnded(_ finishedCoordinator: JDCoordinator) {
		removeChildCoordinator(finishedCoordinator)

		showLogin()
	}

	func questionsAsked(_ finishedCoordinator: JDCoordinator) {
		removeChildCoordinator(finishedCoordinator)

		showEvaluation()
	}

	func loginEnded(_ finishedCoordinator: JDCoordinator) {
		removeChildCoordinator(finishedCoordinator)

		getInitialDataWithIntro(userDataOnly: true, animatedIntro: false)
	}

	// MARK: - Private Methods

	fileprivate func transitionToNextView() {

		if !_userLoggedIn {

			showOnboarding()
		} else {

			if !showQuestion() {
				showEvaluation()
			}
		}
	}

	fileprivate func getInitialDataWithIntro(userDataOnly: Bool, animatedIntro animated: Bool) {
		showIntro(animated: animated)

		getInitialData(userDataOnly: userDataOnly)
	}

	fileprivate func getInitialData(userDataOnly: Bool) {
		let dispatch = DispatchGroup()

		if !userDataOnly {
			dispatch.enter()
			ConstantService.sharedInstance.initiateConstants() { successful in
				NSLog("Got Constants successful: \(successful)")
				dispatch.leave()
			}

			dispatch.enter()
			RemoteConfig.sharedInstance.getRemoteConfigValues { successful in
				NSLog("Got Remote Config successful: \(successful)")
				dispatch.leave()
			}
		}

		dispatch.enter()
		UserLoginService.sharedInstance.checkUserIsLoggedInAndGetData { loggedIn in
			self._userLoggedIn = loggedIn
			NSLog("User is Logged in: \(loggedIn)")
			dispatch.leave()
		}

		dispatch.notify(queue: DispatchQueue.main) {
			self.transitionToNextView()
		}
	}

	// MARK: - Show Methods

	fileprivate func showIntro(animated: Bool) {
		let vc = IntroVC()

		vc.animated = animated

		pushViewController(vc, animated: true)
	}

	fileprivate func showOnboarding() {
		let onboardingCoordinator = OnboardingCoordinator(withNavigationController: navigationController)

		onboardingCoordinator.delegate = self

		addChildCoordinator(onboardingCoordinator)

		onboardingCoordinator.start()
	}

	fileprivate func showLogin() {
		let coordinator = LoginCoordinator(withNavigationController: navigationController)

		coordinator.delegate = self

		addChildCoordinator(coordinator)

		coordinator.start()
	}

	fileprivate func showQuestion() -> Bool {
		guard UserLoginService.sharedInstance.ratedWeeksRelation(withDate: Date()).isDisjoint(with: [.this]) else {
			NSLog("No question needs to be asked")
			return false
		}

		let questions = ConstantService.sharedInstance.ratingQuestions

		guard questions.count > 0 else {
			NSLog("No questions available")
			return false
		}

		let coordinator = QuestionCoordinator(withNavigationController: navigationController)

		coordinator.delegate = self
		coordinator.questions = questions

		addChildCoordinator(coordinator)

		coordinator.start()

		return true
	}

	fileprivate func showEvaluation() {
		let coordinator = EvaluationCoordinator(withNavigationController: navigationController)

		coordinator.delegate = self

		addChildCoordinator(coordinator)

		coordinator.start()
	}
}
