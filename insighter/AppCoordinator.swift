//
//  JDAppCoordinator.swift
//  insighter
//
//  Created by Jan Dammshäuser on 30.08.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import JDCoordinator

class AppCoordinator: JDParentCoordinator, AppCoordinatorDelegate, IntroDelegate {

	private var _userLoggedIn: Bool?

	// MARK: - Coordinator

	override func start() {
		getInitialDataWithIntro(userDataOnly: false, animatedIntro: true)
	}

	// MARK: - Delegates

	func cancelStartup() {
		UserLoginService.unload()
		UserLoginService.shared.signOutUser()

		_userLoggedIn = false
		transitionToNextView()
	}

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

		transitionToNextView(askedQuestions: true)
	}

	func loginEnded(_ finishedCoordinator: JDCoordinator) {
		removeChildCoordinator(finishedCoordinator)

		getInitialDataWithIntro(userDataOnly: true, animatedIntro: false)
	}

	// MARK: - Private Methods

	private func transitionToNextView(askedQuestions asked: Bool = false) {
		guard let loggedIn = _userLoggedIn else {
			return NSLog("[JD] Could not tranisition to next view as userLogin isn't defined")
		}

		if !loggedIn {
			showOnboarding()
		} else {

			if UserLoginService.shared.lastRated.isDisjoint(with: .this) {
				showQuestion()
			} else {
				if asked {
					showIntro(animated: false)
				}
				DataService.shared.getRatings() {
					self.showEvaluation()
				}
			}
		}
	}

	fileprivate func getInitialDataWithIntro(userDataOnly: Bool, animatedIntro animated: Bool) {
		showIntro(animated: animated)

		getInitialData(userDataOnly: userDataOnly)
	}

	private func getInitialData(userDataOnly: Bool) {
		let dispatch = DispatchGroup()

		dispatch.enter()
		UserLoginService.shared.checkUserIsLoggedInAndGetData { [weak self] loggedIn in
			self?._userLoggedIn = loggedIn
			NSLog("[JD] User is Logged in: \(loggedIn)")
			dispatch.leave()
		}

		if !userDataOnly {
			dispatch.enter()
			ConstantService.shared.initiateConstants() { successful in
				NSLog("[JD] Got Constants successful: \(successful)")
				dispatch.leave()
			}

			dispatch.enter()
			RemoteConfig.shared.getRemoteConfigValues { successful in
				NSLog("[JD] Got Remote Config successful: \(successful)")
				dispatch.leave()
			}
		}

		dispatch.notify(queue: DispatchQueue.main) {
			self.transitionToNextView()
		}
	}

	// MARK: - Show Methods

	fileprivate func showIntro(animated: Bool) {
		let vc = IntroVC()

		vc.delegate = self
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

	fileprivate func showQuestion() {
		let coordinator = QuestionCoordinator(withNavigationController: navigationController)

		coordinator.delegate = self

		addChildCoordinator(coordinator)

		coordinator.start()
	}

	fileprivate func showEvaluation() {
		let coordinator = EvaluationCoordinator(withNavigationController: navigationController)

		coordinator.delegate = self

		addChildCoordinator(coordinator)

		coordinator.start()
	}
}
