//
//  OnboardingVC.swift
//  insighter
//
//  Created by Jan Dammshäuser on 09.08.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import UIKit

class OnboardingLoginVC: UIViewController {
    
    private var state: State = .Login
    
    private var dropdownData: [String]!
    
    enum State {
        case Login, Register
    }
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var emailTxt: JDTextField!
    @IBOutlet weak var emailSubLbl: JDLabel!
    @IBOutlet weak var passwordTxt: JDTextField!
    @IBOutlet weak var securitySectionSView: UIStackView!
    @IBOutlet weak var securityQuestionDropdown: JDDropdown!
    @IBOutlet weak var securityAnswerTxt: JDTextField!
    @IBOutlet weak var loginBtn: JDButton!
    
    
    // MARK: - Startup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeDropdown()
        applyState()
    }
    
    
    // MARK: - Actions
    
    @IBAction func loginPressed(sender: UIButton) {
        
        guard let email = emailTxt.text where email != "" else {
            emailTxt.shake()
            print("Nothing entered in Textfields")
            return
        }
        guard let pw = passwordTxt.text where pw != "" && pw.characters.count >= 6 else {
            passwordTxt.shake()
            print("Nothing entered in Textfields")
            return
        }
        
        guard let company = UserService.sharedInstance.companyID(forEmail: email) else {
            print("no Company")
            return
        }
        
        
    }

    
    // MARK: - State Change
    
    private func applyState(s: State? = nil) {
        if let s = s {
            state = s
        }
        
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
