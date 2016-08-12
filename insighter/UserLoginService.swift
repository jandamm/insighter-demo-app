//
//  UserLoginService.swift
//  insighter
//
//  Created by Jan Dammshäuser on 08.08.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import Foundation
import Firebase

class UserLoginService {
    
    //TEST
    var data: String {
        return "Got data:\nUser: \(_userFirebase != nil)\nUserData: \(_userData != nil)\nCompanyData: \(_company != nil)"
    }
    
    
    
    static let sharedInstance = UserLoginService()
    
    private let REF_COMP = FIRDatabase.database().reference().child(DBPathKeys.company.rawValue)
    private let REF_MAIL = FIRDatabase.database().reference().child(DBPathKeys.email.rawValue)
    private let REF_USER = FIRDatabase.database().reference().child(DBPathKeys.user.rawValue)
    
    
    // MARK: - Private Data
    
    private var _userFirebase: FIRUser!
    private var _userData: UserData?
    private var _company: Company?
    private var _emailEndings = [String: String]()
    private var _userListener: FIRAuthStateDidChangeListenerHandle?
    
    
    // MARK: - External Data
    
    func companyID(forEmail mail: String) -> String? {
        let mailParts = mail.componentsSeparatedByString("@")
        let part = mailParts.count - 1
        let ending = mailParts[part]
        return companyID(forEmailEnding: ending)
    }
    
    func companyID(forEmailEnding ending: String) -> String? {
        return _emailEndings[ending]
    }
    
    
    // MARK: - Global Methods
    
    func signOutUser() {
        try! FIRAuth.auth()!.signOut()
        NSLog("User logged out")
    }
    
    func checkUserIsLoggedInAndGetData(completion: CompletionHandlerBool?) {
        getFIRUser(completion)
    }
    
    func updateUserData(userData: UserData, andUploadToFirebase upload: Bool = false) {
        _userData = userData
        
        if upload {
            userData.upload()
        }
    }
    
    func registerUser(withUserData userData: UserData, userGotCreated created: Bool) {
        if created {
            userData.upload()
        }
        
        getFIRUser { _ in
            if created {
                self.addUserToCompanyUserCount()
            }
        }
    }
    
    
    // MARK: - Private Methods
    
    private func addUserToCompanyUserCount() {
        guard let company = _company else {
            NSLog("No Company found")
            return
        }
        
        let child = "\(company.UID)/\(DBPathKeys.Company.value.rawValue)/\(DBValueKeys.CompanyValue.users.rawValue)"
        
        REF_COMP.child(child).observeSingleEventOfType(.Value, withBlock: { snapshot in
            var users = 1
            
            if snapshot.exists(), let count = snapshot.value as? Int {
                users += count
            }
            
            let comp = Company(UID: company.UID, name: company.name, users: users, userNickName: company.userNickName)
            
            self._company = comp
            self.REF_COMP.child(child).setValue(users)
            NSLog("Added User to company count")
        })
    }
    
    private func getUserDataOrEmailEndings(completion: CompletionHandlerBool?) {
        let loggedIn = _userFirebase != nil
        
        if loggedIn {
            getUserDataFromFirebase(completion)
        } else {
            getEmailEndingsFromFirebase(completion)
        }
    }
    
    private func getFIRUser(completion: CompletionHandlerBool?) {
        _userListener = FIRAuth.auth()?.addAuthStateDidChangeListener { auth, user in
            
            self._userFirebase = user
            self.getUserDataOrEmailEndings(completion)
            
            if let listener = self._userListener {
                FIRAuth.auth()?.removeAuthStateDidChangeListener(listener)
                self._userListener = nil
            }
        }
    }
    
    private func getUserDataFromFirebase(completion: CompletionHandlerBool?) {
        let completionValue = true
        let uid = _userFirebase.uid
        
        if let user = _userData where user.UID == uid {
            completion?(completionValue)
            return
        }
        
        NSLog("Checking User data from Firebase")
        
        REF_USER.child(uid).observeSingleEventOfType(.Value, withBlock: { snapshot in
            guard snapshot.exists(), let data = snapshot.value as? [String: AnyObject] else {
                NSLog("No User data available in Firebase")
                completion?(completionValue)
                return
            }
            
            let company = data[DBValueKeys.User.company.rawValue] as? String
            let lastRated = data[DBValueKeys.User.lastRated.rawValue] as? Double
            let securityQuestion = data[DBValueKeys.User.securityQuestion.rawValue] as? String
            let securityAnswer = data[DBValueKeys.User.securityAnswer.rawValue] as? String
            
            let user = UserData(UID: uid, company: company, lastRated: lastRated, securityQuestion: securityQuestion, securityAnswer: securityAnswer)
            
            self._userData = user
            NSLog("Got User data from Firebase")
            
            self.getCompanyFromFirebase(completion)
        })
    }
    
    private func getCompanyFromFirebase(completion: CompletionHandlerBool?) {
        let completionValue = true
        
        guard let user = _userData, let uid = user.company else {
            NSLog("No User or Company found")
            completion?(completionValue)
            return
        }
        
        let child = "\(uid)/\(DBPathKeys.Company.value.rawValue)"
        
        REF_COMP.child(child).observeSingleEventOfType(.Value, withBlock: { snapshot in
            guard snapshot.exists(), let data = snapshot.value as? [String: AnyObject] else {
                NSLog("No Company data available in Firebase")
                completion?(completionValue)
                return
            }
            
            let name = data[DBValueKeys.CompanyValue.name.rawValue] as? String
            let users = data[DBValueKeys.CompanyValue.users.rawValue] as? Int
            let userNickName = data[DBValueKeys.CompanyValue.userNickName.rawValue] as? String
            
            let company = Company(UID: uid, name: name, users: users, userNickName: userNickName)
            
            self._company = company
            NSLog("Got Company data from Firebase")
            
            completion?(completionValue)
        })
    }
    
    private func getEmailEndingsFromFirebase(completion: CompletionHandlerBool?) {
        let completionValue = false
        
        guard _userFirebase == nil && _emailEndings.count == 0 else {
            completion?(completionValue)
            return
        }
        
        NSLog("Checking Email Endings from Firebase")
        
        REF_MAIL.observeSingleEventOfType(.Value, withBlock: { snapshot in
            guard snapshot.exists(), let data = snapshot.value as? [String: [String: String]] else {
                NSLog("No Email data available in Firebase")
                completion?(completionValue)
                return
            }
            
            var mails = [String: String]()
            
            for (_, mail) in data {
                if let companyID = mail[DBValueKeys.Email.company.rawValue], let ending = mail[DBValueKeys.Email.ending.rawValue] {
                    mails[ending] = companyID
                }
            }
            
            self._emailEndings = mails
            NSLog("Got Email Endings from Firebase")
            
            completion?(completionValue)
        })
    }
}