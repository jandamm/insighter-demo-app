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
		case Login, Register
	}

	var state: State = .Login {
		didSet {
			applyState()
		}
	}

	// MARK: - ErrorType

	private enum ErrorType {
		case Email, Password, Security, SwitchState

		static private var email: Set = ["ERROR_INVALID_EMAIL", "ERROR_EMAIL_ALREADY_IN_USE"]
		static private var password: Set = ["ERROR_WEAK_PASSWORD", "ERROR_WRONG_PASSWORD"]
		static private var switchState: Set = ["ERROR_USER_NOT_FOUND"]

		static func errorType(forString s: String) -> ErrorType? {
			if email.contains(s) {
				return .Email
			} else if password.contains(s) {
				return .Password
			} else if switchState.contains(s) {
				return .SwitchState
			}

			return nil
		}
	}

	// MARK: - Private Data

	private var dropdownData: [String]!

	// MARK: - Outlets

	@IBOutlet weak var emailTxt: JDTextField!
	@IBOutlet weak var emailSubLbl: JDLabel!

	@IBOutlet weak var passwordTxt: JDTextField!
	@IBOutlet weak var passwordSubLbl: JDLabel!

	@IBOutlet weak var securitySectionSView: UIStackView!
	@IBOutlet weak var securityQuestionDropdown: JDDropdown!
	@IBOutlet weak var securityAnswerTxt: JDTextField!
	@IBOutlet weak var securitySubLbl: JDLabel!

	@IBOutlet weak var loginBtn: JDButton!

	// MARK: - Startup

	override func viewDidLoad() {
		super.viewDidLoad()

		initializeDropdown()
		applyState()
	}

	// MARK: - Actions

	@IBAction func loginPressed(sender: UIButton) {
		resetSubLbls()

		delegate?.login(withEmail: emailTxt.text, password: passwordTxt.text, question: securityQuestionDropdown.selection, answer: securityAnswerTxt.text, errorHandler: errorHandling)
	}

	// MARK: - Error Handling

	private func errorHandling(withString rConfig: String?) {
		guard let remoteConfig = rConfig, let type = ErrorType.errorType(forString: remoteConfig) else {
			NSLog("Unknown Firebase Error occurred: \(rConfig)")
			return errorUndefined()
		}

		let remoteConfigKey = RemoteStringKey(rawValue: remoteConfig)

		if remoteConfigKey != nil || type == .SwitchState {
			errorHandling(forType: type, withRemoteConfig: remoteConfigKey)
		} else {
			errorUndefined()
		}
	}

	private func errorHandling(forType type: ErrorType, withRemoteConfig remoteConfigKey: RemoteStringKey!) {
		switch type {
		case .SwitchState:
			state = .Register
		case .Email:
			emailSubLbl.remoteConfigKey = remoteConfigKey.rawValue
			emailTxt.shake()
		case .Password:
			passwordSubLbl.remoteConfigKey = remoteConfigKey.rawValue
			passwordTxt.shake()
		case .Security:
			securitySubLbl.remoteConfigKey = remoteConfigKey.rawValue
			securityAnswerTxt.shake()
		}
	}

	private func errorUndefined() {
		let HUD = JDPopup(titleKey: .ERROR_UNKNOWN_TITLE, subTitleKey: .ERROR_UNKNOWN_EXPLANATION, imageStyle: .Error)
		HUD.showInView(view)
	}

	// MARK: - State Change

	private func applyState() {
		switch state {
		case .Login:
			loginState()
		case .Register:
			registerState()
		}
	}

	private func loginState() {
		guard state == .Login else {
			return
		}

		securitySectionSView.hidden = true
		securitySectionSView.alpha = 0
		passwordTxt.NextResponder = loginBtn
		passwordTxt.returnKeyType = .Done
	}

	private func registerState() {
		guard state == .Register else {
			return
		}

		passwordTxt.NextResponder = securityAnswerTxt
		passwordTxt.returnKeyType = .Next

		UIView.animateWithDuration(0.5) {
			self.securitySectionSView.hidden = false
			self.securitySectionSView.alpha = 1
		}
	}

	// MARK: - Private Methods

	private func resetSubLbls() {
		emailSubLbl.resetRemoteConfigText()
		passwordSubLbl.resetRemoteConfigText()
		securitySubLbl.resetRemoteConfigText()
	}

	private func initializeDropdown() {
		dropdownData = ConstantService.sharedInstance.securityQuestions
		securityQuestionDropdown.dataSource(dropdownData)
	}
}
