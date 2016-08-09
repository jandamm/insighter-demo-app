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
    
    private let REF = FIRDatabase.database().reference().child(DBPathKeys.user.value)
    
    // MARK: - Private Data
    
    private var _userFirebase: FIRUser!
    private var _userData: User?
    private var _addedUserListener = false
    
    
    // MARK: - External Data
    
    
    // MARK: - Global Methods
    
    func userIsLoggedIn(completion: CompletionHandlerBool?) {
        if !_addedUserListener {
            addListener(completion)
        } else {
            completion?(_userFirebase != nil)
        }
    }
    
    
    // MARK: - Private Methods
    
    private func addListener(completion: CompletionHandlerBool?) {
        FIRAuth.auth()?.addAuthStateDidChangeListener { auth, user in
            if let user = user {
                self._userFirebase = user
                self.getUserData()
                completion?(true)
            } else {
                completion?(false)
            }
        }
    }
    
    private func getUserData() {
        let uid = _userFirebase.uid
        
        REF.child(uid).observeSingleEventOfType(.Value, withBlock: { snapshot in
            guard snapshot.exists(), let data = snapshot.value else {
                NSLog("No User data available in Firebase")
                return
            }
            
            let company = data[DBValueKeys.User.company] as? String
            let lastRated = data[DBValueKeys.User.lastRated] as? String
        })
    }
}
