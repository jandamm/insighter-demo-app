//
//  OnboardingVC.swift
//  insighter
//
//  Created by Jan Dammshäuser on 09.08.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import UIKit

class OnboardingLoginVC: UIViewController, FIRLoginable {
    
    // MARK: - State
    
    private enum State {
        case Login, Register
    }
    
    private var state: State = .Login {
        didSet {
            applyState()
        }
    }
    
    // MARK: - ErrorType
    
    private enum ErrorType {
        case Email, Password, Security, SwitchState
        
        static private var email: Set = ["ERROR_INVALID_EMAIL", "ERROR_EMAIL_ALREADY_IN_USE"]
        static private var password: Set = ["ERROR_WEAK_PASSWORD", "ERROR_WRONG_PASSWORD"]
        static private var switchState : Set = ["ERROR_USER_NOT_FOUND"]
        
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
    private var company: String?
    private var securityQuestion: String?
    private var securityAnswer: String?
    
    
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
        loginManager()
    }
    
    
    // MARK: - Login
    
    private func loginManager() {
        resetSubLbls()
        
        guard let email = emailTxt.text where email.isValidEmail else {
            return errorHandling(forType: .Email, withRemoteConfig: .ERROR_INVALID_EMAIL)
        }
        guard let password = passwordTxt.text where password.characters.count >= 6 else {
            return errorHandling(forType: .Password, withRemoteConfig: .ERROR_WEAK_PASSWORD)
        }
        guard let company = UserLoginService.sharedInstance.companyID(forEmail: email) else {
            return errorHandling(forType: .Email, withRemoteConfig: .ERROR_COMPANY_UNKNOWN)
        }
        
        self.company = company
        
        switch state {
        case .Login:
            loginUser(withEmail: email, andPassword: password, completion: loginResponseHandler)
        case .Register:
            guard let question = securityQuestionDropdown.selection else {
                return errorHandling(forType: .Security, withRemoteConfig: .ERROR_QUESTION_NOT_CHOSEN)
            }
            guard let answer = securityAnswerTxt.text where answer.characters.count >= 3 else {
                return errorHandling(forType: .Security, withRemoteConfig: .ERROR_QUESTION_ANSWER_TOO_SHORT)
            }
            
            self.securityQuestion = question
            self.securityAnswer = answer
            
            createUser(forEmail: email, andPassword: password, completion: loginResponseHandler)
        }
    }
    
    private func loginResponseHandler(uid: String?, error: AnyObject?, created: Bool) {
        
        if let uid = uid {
            registerUser(withID: uid, isCreated: created)
            
            NSLog("User is logged in")
            transitionToNextView()
            
        } else if let error = error {
            errorHandling(withString: String(error))
        } else {
            errorUndefined()
        }
    }
    
    private func registerUser(withID uid: String, isCreated created: Bool) {
        let userData = UserData(UID: uid, company: company, lastRated: nil, securityQuestion: securityQuestion, securityAnswer: securityAnswer)
        
        UserLoginService.sharedInstance.registerUser(withUserData: userData, userGotCreated: created)
    }
    
    
    // MARK: - Error Handling
    
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
    
    private func errorHandling(withString remoteConfig: String) {
        guard let type = ErrorType.errorType(forString: remoteConfig) else {
            NSLog("Unknown Firebase Error occurred: \(remoteConfig)")
            return errorUndefined()
        }
        
        let remoteConfigKey = RemoteStringKey(rawValue: remoteConfig)
        
        if remoteConfigKey != nil || type == .SwitchState {
            errorHandling(forType: type, withRemoteConfig: remoteConfigKey)
        } else {
            errorUndefined()
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
        passwordTxt.NextResponder = loginBtn
        passwordTxt.returnKeyType = .Done
        loginBtn.remoteConfigKey = RemoteStringKey.Onb_Login_Anmeldung_Btn_Log.rawValue
    }
    
    private func registerState() {
        guard state == .Register else {
            return
        }
        
        passwordTxt.NextResponder = securityAnswerTxt
        passwordTxt.returnKeyType = .Next
        loginBtn.remoteConfigKey = RemoteStringKey.Onb_Login_Anmeldung_Btn_Reg.rawValue
        
        UIView.animateWithDuration(0.5) { 
            self.securitySectionSView.hidden = false
        }
    }
    
    
    // MARK: - Private Methods
    
    private func transitionToNextView() {
        performSegueWithIdentifier(Segue.OnboardingLoginToAuswertung.rawValue, sender: nil)
    }
    
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
