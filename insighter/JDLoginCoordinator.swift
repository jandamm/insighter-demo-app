//
//  JDLoginCoordinator.swift
//  insighter
//
//  Created by Jan Dammshäuser on 30.08.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import UIKit

protocol LoginDelegate: Coordinator {
    func loginManager(email email: String?, password: String?, question: String?, answer: String?, errorHandler: CompletionHandlerFirebaseLoginError)
}

protocol JDLoginCoordinatorDelegate: Coordinator {
    func loginEnded<C where C: NSObject, C: Coordinator>(finishedCoordinator: C)
}

class JDLoginCoordinator: NSObject, FIRLoginable, Coordinator, LoginDelegate {
    
    weak var delegate: JDLoginCoordinatorDelegate?
    
    private var company: String?
    private var securityQuestion: String?
    private var securityAnswer: String?
    
    private var loginVC: LoginVC?
    
    
    // MARK: - Coordinator
    
    let navigationController: UINavigationController
    
    var childCoordinator = [NSObject]()
    
    required init(withNavigationController navigationController: UINavigationController) {
        self.navigationController = navigationController
        
        super.init()
    }
    
    func start() {
        let vc = LoginVC()
        
        vc.delegate = self
        
        loginVC = vc
        
        navigationController.pushViewController(vc, animated: true)
    }
    
    
    // MARK: - Delegates
    
    func loginManager(email email: String?, password: String?, question: String?, answer: String?, errorHandler: CompletionHandlerFirebaseLoginError) {
        guard let loginVC = loginVC else {
            errorHandler?(nil)
            return
        }
        
        guard let email = email where email.isValidEmail else {
            errorHandler?("ERROR_INVALID_EMAIL")
            return
        }
        guard let password = password where password.characters.count >= 6 else {
            errorHandler?("ERROR_WEAK_PASSWORD")
            return
        }
        guard let company = UserLoginService.sharedInstance.companyID(forEmail: email) else {
            errorHandler?("ERROR_COMPANY_UNKNOWN")
            return
        }
        
        self.company = company
        
        switch loginVC.state {
        case .Login:
            loginUser(withEmail: email, andPassword: password, completion: loginResponseHandler, errorHandler: errorHandler)
        case .Register:
            guard let question = question else {
                errorHandler?("ERROR_QUESTION_NOT_CHOSEN")
                return
            }
            guard let answer = answer where answer.characters.count >= 3 else {
                errorHandler?("ERROR_QUESTION_ANSWER_TOO_SHORT")
                return
            }
            
            self.securityQuestion = question
            self.securityAnswer = answer.trimmed
            
            createUser(forEmail: email, andPassword: password, completion: loginResponseHandler, errorHandler: errorHandler)
        }
    }
    
    
    // MARK: - Private Methods
    
    private func loginResponseHandler(uid: String?, error: AnyObject?, created: Bool, errorHandler: CompletionHandlerFirebaseLoginError) {
        
        if let uid = uid {
            registerUser(withID: uid, isCreated: created, errorHandler: errorHandler)
        } else if let error = error {
            errorHandler?(String(error))
        } else {
            errorHandler?(nil)
        }
    }
    
    private func registerUser(withID uid: String, isCreated created: Bool, errorHandler: CompletionHandlerFirebaseLoginError) {
        let userData = UserData(UID: uid, company: company, lastRated: nil, previousRated: nil, securityQuestion: securityQuestion, securityAnswer: securityAnswer)
        
        UserLoginService.sharedInstance.registerNewUser(withUserData: userData)
        
        NotificationService.sharedInstance.setupNotifications()
        
        finish()
    }
    
    private func finish() {
        loginVC = nil
        delegate?.loginEnded(self)
    }
}
