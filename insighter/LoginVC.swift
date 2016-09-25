//
//  OnboardingVC.swift
//  insighter
//
//  Created by Jan Dammshäuser on 09.08.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

	weak var delegate: LoginDelegate?

	// MARK: - State

	enum State {
		case login, register
	}

	var state: State = .login {
		didSet {
			applyState()
		}
	}

	// MARK: - ErrorType

	fileprivate enum ErrorType {
		case email, password, security, switchState

		private static var emails: Set = ["ERROR_INVALID_EMAIL", "ERROR_EMAIL_ALREADY_IN_USE", "ERROR_COMPANY_UNKNOWN"]
		private static var passwords: Set = ["ERROR_WEAK_PASSWORD", "ERROR_WRONG_PASSWORD"]
		private static var securities: Set = ["ERROR_QUESTION_NOT_CHOSEN", "ERROR_QUESTION_ANSWER_TOO_SHORT"]
		private static var switchStates: Set = ["ERROR_USER_NOT_FOUND"]

		static func errorType(forString s: String) -> ErrorType? {
			if emails.contains(s) {
				return .email
			} else if passwords.contains(s) {
				return .password
			} else if securities.contains(s) {
				return .security
			} else if switchStates.contains(s) {
				return .switchState
			}

			return nil
		}
	}

	// MARK: - Private Data

	fileprivate var dropdownData: [String]!

	// MARK: - Outlets

	@IBOutlet weak var emailTxt: JDTextField!
	@IBOutlet weak var emailSubLbl: JDLabel!

	@IBOutlet weak var passwordTxt: JDTextField!
	@IBOutlet weak var passwordSubLbl: JDLabel!

	@IBOutlet weak var demoAccountView: UIStackView!
	@IBOutlet weak var demoAccountSwitch: JDSwitch!

	@IBOutlet weak var securitySectionView: UIStackView!
	@IBOutlet weak var securityQuestionDropdown: JDDropdown!
	@IBOutlet weak var securityAnswerTxt: JDTextField!
	@IBOutlet weak var securitySubLbl: JDLabel!

	@IBOutlet weak var loginBtn: JDButton!

	// MARK: - Startup

	override func viewDidLoad() {
		super.viewDidLoad()

		initializeDropdown()
		demoAccountView.isHidden = true
		applyState()
	}

	// MARK: - Actions

	@IBAction func loginPressed(_ sender: UIButton) {
		resetSubLbls()

		delegate?.login(withEmail: emailTxt.text, password: passwordTxt.text, question: securityQuestionDropdown.selection, answer: securityAnswerTxt.text, errorHandler: errorHandling)
	}

	// MARK: - Error Handling

	fileprivate func errorHandling(withString rConfig: String?) {
		guard let remoteConfig = rConfig, let type = ErrorType.errorType(forString: remoteConfig) else {
			NSLog("[JD] Unknown Firebase Error occurred: \(rConfig)")
			return errorUndefined()
		}

		let remoteConfigKey = RemoteStringKey(rawValue: remoteConfig)

		if remoteConfigKey != nil || type == .switchState {
			errorHandling(forType: type, withRemoteConfig: remoteConfigKey)
		} else {
			errorUndefined()
		}
	}

	fileprivate func errorHandling(forType type: ErrorType, withRemoteConfig remoteConfigKey: RemoteStringKey!) {
		switch type {
		case .switchState:
			state = .register
		case .email:
			if remoteConfigKey == RemoteStringKey.ERROR_COMPANY_UNKNOWN {
				animate(stackViewIn: demoAccountView)
			}
			emailSubLbl.remoteConfigKey = remoteConfigKey.rawValue
			emailTxt.shake()
		case .password:
			passwordSubLbl.remoteConfigKey = remoteConfigKey.rawValue
			passwordTxt.shake()
		case .security:
			securitySubLbl.remoteConfigKey = remoteConfigKey.rawValue
			securityAnswerTxt.shake()
		}
	}

	fileprivate func errorUndefined() {
		let HUD = JDPopup(titleKey: .ERROR_UNKNOWN_TITLE, subTitleKey: .ERROR_UNKNOWN_EXPLANATION, imageStyle: .error)
		HUD.show(in: view)
	}

	// MARK: - State Change

	fileprivate func applyState() {
		switch state {
		case .login:
			loginState()
		case .register:
			registerState()
		}
	}

	fileprivate func loginState() {
		guard state == .login else {
			return
		}

		securitySectionView.isHidden = true
		securitySectionView.alpha = 0
		passwordTxt.NextResponder = loginBtn
		passwordTxt.returnKeyType = .done
	}

	fileprivate func registerState() {
		guard state == .register else {
			return
		}

		passwordTxt.NextResponder = securityAnswerTxt
		passwordTxt.returnKeyType = .next

		animate(stackViewIn: securitySectionView)
	}

	fileprivate func animate(stackViewIn stackView: UIStackView) {
		UIView.animate(withDuration: 0.5, animations: {
			stackView.isHidden = false
			stackView.alpha = 1
		})
	}

	// MARK: - Private Methods

	fileprivate func resetSubLbls() {
		emailSubLbl.resetRemoteConfigText()
		passwordSubLbl.resetRemoteConfigText()
		securitySubLbl.resetRemoteConfigText()
	}

	fileprivate func initializeDropdown() {
		dropdownData = ConstantService.shared.securityQuestions
		securityQuestionDropdown.dataSource(dropdownData)
	}
}
