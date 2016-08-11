//
//  OnboardingVC.swift
//  insighter
//
//  Created by Jan Dammshäuser on 09.08.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import UIKit
import Firebase

class OnboardingLoginVC: UIViewController, FIRLoginable {
    
    // MARK: - State
    
    enum State {
        case Login, Register
    }
    private let stateSwitchValue = "ERROR_USER_NOT_FOUND"
    private var state: State = .Login {
        didSet {
            applyState()
        }
    }
    
    
    // MARK: - Private Data
    
    private var dropdownData: [String]!
    private var company: String?
    
    
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
        guard let email = emailTxt.text where email.isValidEmail else {
            errorHandling(forType: .Email, withRemoteConfig: .ERROR_INVALID_EMAIL)
            return
        }
        guard let password = passwordTxt.text where password.characters.count >= 6 else {
            errorHandling(forType: .Password, withRemoteConfig: .ERROR_WEAK_PASSWORD)
            return
        }
        guard let company = UserService.sharedInstance.companyID(forEmail: email) else {
            errorHandling(forType: .Email, withRemoteConfig: .ERROR_COMPANY_UNKNOWN)
            return
        }
        
        self.company = company
        
        switch state {
        case .Login:
            loginUser(withEmail: email, andPassword: password, completion: loginResponseHandler)
        case .Register:
            //TODO
            print("checking question")
            
            
            createUser(forEmail: email, andPassword: password, completion: loginResponseHandler)
        }
    }
    
    private func loginResponseHandler(uid: String?, error: AnyObject?, created: Bool) {
        if let uid = uid {
            NSLog("User is logged in")
            if created {
                createUserData(withID: uid)
            }
        } else if let error = error where String(error) == stateSwitchValue {
            //TODO
        } else if let error = error {
            errorHandling(forType: .Email, withString: String(error))
        } else {
            errorUndefined()
        }
    }
    
    private func createUserData(withID uid: String) {
        //TODO
        print(uid)
        print("set in userservice")
        print("upload")
    }
    
    // MARK: - Error Handling
    
    enum ErrorType {
        case Email, Password, Security
    }
    
    private func errorHandling(forType type: ErrorType, withRemoteConfig remoteConfigKey: RemoteConfigKey) {
        //TODO
        print(remoteConfigKey)
    }
    
    private func errorHandling(forType type: ErrorType, withString remoteConfig: String) {
        guard let remoteConfigKey = RemoteConfigKey(rawValue: remoteConfig) else {
            errorUndefined()
            return
        }
        
        errorHandling(forType: type, withRemoteConfig: remoteConfigKey)
    }

    private func errorUndefined() {
        //TODO
        print("Something went badly wrong -> implement alert")
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
        loginBtn.remoteConfigKey = RemoteConfigKey.Onb_Login_Anmeldung_Btn_Login.rawValue
    }
    
    private func registerState() {
        guard state == .Register else {
            return
        }
        
        passwordTxt.NextResponder = securityAnswerTxt
        loginBtn.remoteConfigKey = RemoteConfigKey.Onb_Login_Anmeldung_Btn_Register.rawValue
        
        UIView.animateWithDuration(0.5) { 
            self.securitySectionSView.hidden = false
        }
    }
    
    
    // MARK: - Private Methods
    
    func initializeDropdown() {
        dropdownData = ConstantService.sharedInstance.securityQuestions
        securityQuestionDropdown.dataSource(dropdownData)
    }
}
