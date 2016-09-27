//
//  JDLoginCoordinator.swift
//  insighter
//
//  Created by Jan Dammshäuser on 30.08.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import JDCoordinator

protocol LoginDelegate: JDCoordinatorDelegate {
	func login(withEmail email: String?, password: String?, question: String?, answer: String?, errorHandler: CompletionHandlerFirebaseLoginError)
}

class LoginCoordinator: JDCoordinator, FIRLoginable, LoginDelegate {

	weak var delegate: LoginCoordinatorDelegate?

	fileprivate var company: String?
	fileprivate var securityQuestion: String?
	fileprivate var securityAnswer: String?

	fileprivate var loginVC: LoginVC?

	// MARK: - Coordinator

	override func start() {
		showLogin()
	}

	// MARK: - Delegates

	func login(withEmail email: String?, password: String?, question: String?, answer: String?, errorHandler: CompletionHandlerFirebaseLoginError) {
		guard let loginVC = loginVC else {
			errorHandler?(nil)
			return
		}

		guard let email = email, email.isValidEmail else {
			errorHandler?("ERROR_INVALID_EMAIL")
			return
		}
		guard let password = password, password.characters.count >= 6 else {
			errorHandler?("ERROR_WEAK_PASSWORD")
			return
		}

		let company = UserLoginService.shared.companyID(forEmail: email)
		guard company != nil || loginVC.demoAccountSwitch.isOn else {
			errorHandler?("ERROR_COMPANY_UNKNOWN")
			return
		}

		self.company = company ?? ConstantService.shared.demoCompany

		switch loginVC.state {
		case .login:
			loginUser(withEmail: email, andPassword: password, completion: loginResponseHandler, errorHandler: errorHandler)
		case .register:
			guard let question = question else {
				errorHandler?("ERROR_QUESTION_NOT_CHOSEN")
				return
			}
			guard let answer = answer, answer.characters.count >= 3 else {
				errorHandler?("ERROR_QUESTION_ANSWER_TOO_SHORT")
				return
			}

			self.securityQuestion = question
			self.securityAnswer = answer.trimmed

			createUser(forEmail: email, andPassword: password, completion: loginResponseHandler, errorHandler: errorHandler)
		}
	}

	// MARK: - Private Methods

	fileprivate func loginResponseHandler(_ uid: String?, error: String?, created: Bool, errorHandler: CompletionHandlerFirebaseLoginError) {

		if let uid = uid {
			registerUser(withID: uid, isCreated: created, errorHandler: errorHandler)
		} else if let error = error {
			errorHandler?(String(describing: error))
		} else {
			errorHandler?(nil)
		}
	}

	fileprivate func registerUser(withID uid: String, isCreated created: Bool, errorHandler: CompletionHandlerFirebaseLoginError) {
		let userData = UserData(UID: uid, company: company, score: nil, ratedOne: nil, ratedTwo: nil, securityQuestion: securityQuestion, securityAnswer: securityAnswer)

		UserLoginService.shared.registerNewUser(withUserData: userData)

		NotificationService.shared.setupNotifications()

		finish()
	}

	fileprivate func finish() {
		loginVC = nil
		delegate?.loginEnded(self)
	}

	// MARK: - Show Methods

	fileprivate func showLogin() {
		let vc = LoginVC()

		vc.delegate = self

		loginVC = vc

		setViewControllers(vc, animated: true)
	}
}
