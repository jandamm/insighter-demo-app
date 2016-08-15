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
    
    //TEST for beta
    var data: String {
        return "Got data:\nUser: \(_userFirebase != nil)\nUserData: \(_userData != nil)\nCompanyData: \(_company != nil)"
    }
    
    
    
    static let sharedInstance = UserLoginService()
    
    private let REF_COMP = FIRDatabase.database().reference().child(DBPathKeys.company.rawValue)
    private let REF_MAIL = FIRDatabase.database().reference().child(DBPathKeys.email.rawValue)
    private let REF_USER = FIRDatabase.database().reference().child(DBPathKeys.user.rawValue)
    
    
    // MARK: - Private Data
    
    private var _userFirebase: FIRUser!
    private var _userData: UserData!
    private var _company: Company!
    private var _emailEndings = [String: String]()
    private var _userListener: FIRAuthStateDidChangeListenerHandle?
    
    
    // MARK: - External Data
    
    var userID: String! {
        return _userData.UID
    }
    
    var companyID: String! {
        return _company.UID
    }
    
    func ratedWeeksRelation(withDate date: NSDate) -> Set<CalendarWeek.Relation> {
        guard let userData = _userData else {
            return [.None]
        }
        
        let relationLast = userData.lastRated.calenderWeekRelation(forDate: date)
        let relationPrevious = userData.previousRated.calenderWeekRelation(forDate: date)
        
        return [relationLast, relationPrevious]
    }
    
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
    
    func signOutUser(completion: CompletionHandlerBool? = nil) {
        try! FIRAuth.auth()!.signOut()
        
        _userFirebase = nil
        _userData = nil
        _company = nil
        
        NSLog("User logged out")
        getEmailEndingsFromFirebase(completion, forcedCompletionValue: nil)
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
    
    func registerUser(withUserData userData: UserData, userGotCreated created: Bool, completion: CompletionHandlerBool?) {
        if created {
            userData.upload()
        }
        
        getFIRUser { loggedIn in
            if created {
                self.addUserToCompanyUserCount()
            }
            
            completion?(loggedIn)
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
            getUserDataFromFirebase(completion, forcedCompletionValue: loggedIn)
        } else {
            getEmailEndingsFromFirebase(completion, forcedCompletionValue: loggedIn)
        }
    }
    
    private func getFIRUser(completion: CompletionHandlerBool?) {
        _userListener = FIRAuth.auth()?.addAuthStateDidChangeListener { auth, user in
            guard self._userFirebase == nil else {
                return
            }
            
            self._userFirebase = user
            self.getUserDataOrEmailEndings(completion)
            
            if let listener = self._userListener {
                FIRAuth.auth()?.removeAuthStateDidChangeListener(listener)
                self._userListener = nil
            }
        }
    }
    
    private func getUserDataFromFirebase(completion: CompletionHandlerBool?, forcedCompletionValue: Bool?) {
        let uid = _userFirebase.uid
        
        if let user = _userData where user.UID == uid {
            self.complete(completion, withForcedValue: forcedCompletionValue, andRealValue: false)
            return
        }
        
        NSLog("Checking User data from Firebase")
        
        REF_USER.child(uid).observeSingleEventOfType(.Value, withBlock: { snapshot in
            guard snapshot.exists(), let data = snapshot.value as? [String: AnyObject] else {
                NSLog("No User data available in Firebase")
                self.complete(completion, withForcedValue: forcedCompletionValue, andRealValue: false)
                return
            }
            
            let company = data[DBValueKeys.User.company.rawValue] as? String
            let lastRated = data[DBValueKeys.User.lastRated.rawValue] as? Double
            let previousRated = data[DBValueKeys.User.previousRated.rawValue] as? Double
            let securityQuestion = data[DBValueKeys.User.securityQuestion.rawValue] as? String
            let securityAnswer = data[DBValueKeys.User.securityAnswer.rawValue] as? String
            
            let user = UserData(UID: uid, company: company, lastRated: lastRated, previousRated: previousRated, securityQuestion: securityQuestion, securityAnswer: securityAnswer)
            
            self._userData = user
            NSLog("Got User data from Firebase")
            
            self.getCompanyFromFirebase(completion, forcedCompletionValue: nil)
        })
    }
    
    private func getCompanyFromFirebase(completion: CompletionHandlerBool?, forcedCompletionValue: Bool?) {
        guard let user = _userData, let uid = user.company else {
            NSLog("No User or Company found")
            self.complete(completion, withForcedValue: forcedCompletionValue, andRealValue: false)
            return
        }
        
        let child = "\(uid)/\(DBPathKeys.Company.value.rawValue)"
        
        REF_COMP.child(child).observeSingleEventOfType(.Value, withBlock: { snapshot in
            guard snapshot.exists(), let data = snapshot.value as? [String: AnyObject] else {
                NSLog("No Company data available in Firebase")
                self.complete(completion, withForcedValue: forcedCompletionValue, andRealValue: false)
                return
            }
            
            let name = data[DBValueKeys.CompanyValue.name.rawValue] as? String
            let users = data[DBValueKeys.CompanyValue.users.rawValue] as? Int
            let userNickName = data[DBValueKeys.CompanyValue.userNickName.rawValue] as? String
            
            let company = Company(UID: uid, name: name, users: users, userNickName: userNickName)
            
            self._company = company
            NSLog("Got Company data from Firebase")
            
            self.complete(completion, withForcedValue: forcedCompletionValue, andRealValue: true)
        })
    }
    
    private func getEmailEndingsFromFirebase(completion: CompletionHandlerBool?, forcedCompletionValue: Bool?) {
        guard _userFirebase == nil && _emailEndings.count == 0 else {
            complete(completion, withForcedValue: forcedCompletionValue, andRealValue: false)
            return
        }
        
        NSLog("Checking Email Endings from Firebase")
        
        REF_MAIL.observeSingleEventOfType(.Value, withBlock: { snapshot in
            guard snapshot.exists(), let data = snapshot.value as? [String: [String: String]] else {
                NSLog("No Email data available in Firebase")
                self.complete(completion, withForcedValue: forcedCompletionValue, andRealValue: false)
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
            
            self.complete(completion, withForcedValue: forcedCompletionValue, andRealValue: true)
        })
    }
    
    private func complete(completion : CompletionHandlerBool?, withForcedValue forced: Bool?, andRealValue value: Bool) {
        if let forced = forced {
            completion?(forced)
        } else {
            completion?(value)
        }
    }
}
