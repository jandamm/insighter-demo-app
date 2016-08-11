//
//  DataService.swift
//  betapp
//
//  Created by Jan Dammshäuser on 22.07.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import Foundation
import Firebase

protocol FIRLoginable { }

extension FIRLoginable {
    
    func loginUser(withEmail email: String, andPassword password: String, completion: CompletionHandlerFirebaseLogin) {
        NSLog("Attempt Login with Firebase")
        FIRAuth.auth()?.signInWithEmail(email, password: password) { user, error in
            if user?.uid != nil {
                NSLog("Logged in with Firebase")
            }
            let errorKey = error?.userInfo[FIRAuthErrorNameKey]
            
            completion(user?.uid, errorKey, true)
        }
    }
    
    func createUser(forEmail email: String, andPassword password: String, completion: CompletionHandlerFirebaseLogin) {
        NSLog("Attempt Registration at Firebase")
        FIRAuth.auth()?.createUserWithEmail(email, password: password) { user, error in
            if user?.uid != nil {
                NSLog("Registered at Firebase")
            }
            let errorKey = error?.userInfo[FIRAuthErrorNameKey]
            
            completion(user?.uid, errorKey, true)
        }
    }
    
}

