//
//  UserService.swift
//  insighter
//
//  Created by Jan Dammshäuser on 08.08.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import Foundation
import Firebase

class UserService {
    static let sharedInstance = UserService()
    
    private let REF_USER = FIRDatabase.database().reference().child(DBPathKeys.user.rawValue)
    private let REF_MAIL = FIRDatabase.database().reference().child(DBPathKeys.email.rawValue)
    
    // MARK: - Private Data
    
    private var _userFirebase: FIRUser!
    private var _userData: User?
    private var _emailEndings = [String: String]()
    private var _addedUserListener = false
    private var _gotEmailEndings = false
    
    
    // MARK: - External Data
    
    
    // MARK: - Global Methods
    
    func userIsLoggedIn(completion: CompletionHandlerBool?) {
        if !_addedUserListener {
            addListener(completion)
        } else {
            let loggedIn = _userFirebase != nil
            
            if !loggedIn {
                getEmailEndings()
            }
            
            completion?(loggedIn)
        }
    }
    
    func companyID(forEmailEnding mail: String) -> String? {
        return _emailEndings[mail]
    }
    
    
    // MARK: - Private Methods
    
    private func addListener(completion: CompletionHandlerBool?) {
        _addedUserListener = true
        
        FIRAuth.auth()?.addAuthStateDidChangeListener { auth, user in
            if let user = user {
                self._userFirebase = user
                self.getUserData()
                completion?(true)
            } else {
                self.getEmailEndings()
                completion?(false)
            }
        }
    }
    
    private func getUserData() {
        let uid = _userFirebase.uid
        
        if let user = _userData where user.UID == uid {
            return
        }
        
        NSLog("Checking User data from Firebase")
        
        REF_USER.child(uid).observeSingleEventOfType(.Value, withBlock: { snapshot in
            guard snapshot.exists(), let data = snapshot.value as? [String: AnyObject] else {
                NSLog("No User data available in Firebase")
                return
            }
            
            let company = data[DBValueKeys.User.company.rawValue] as? String
            let lastRated = data[DBValueKeys.User.lastRated.rawValue] as? String
            
            let user = User(UID: uid, company: company, lastRated: lastRated)
            
            self._userData = user
            NSLog("Got User data from Firebase")
        })
    }
    
    private func getEmailEndings() {
        guard _userFirebase == nil && _emailEndings.count == 0 else {
            return
        }
        
        NSLog("Checking Email Endings from Firebase")
        
        REF_MAIL.observeSingleEventOfType(.Value, withBlock: { snapshot in
            guard snapshot.exists(), let data = snapshot.value as? [String: [String: String]] else {
                NSLog("No Email data available in Firebase")
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
        })
    }
}
