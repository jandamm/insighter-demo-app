//
//  DataService.swift
//  betapp
//
//  Created by Jan Dammshäuser on 22.07.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import Foundation
import Firebase

protocol FIRLoginable {}

extension FIRLoginable {

	func loginUser(withEmail email: String, andPassword password: String, completion: @escaping CompletionHandlerFirebaseLogin, errorHandler: CompletionHandlerFirebaseLoginError) {
		NSLog("Attempt Login with Firebase")
		FIRAuth.auth()?.signIn(withEmail: email, password: password) { user, error in
			if user?.uid != nil {
				NSLog("Logged in with Firebase")
			}
			let errorKey = error?.userInfo[FIRAuthErrorNameKey]

			completion(user?.uid, errorKey, false, errorHandler)
		}
	}

	func createUser(forEmail email: String, andPassword password: String, completion: @escaping CompletionHandlerFirebaseLogin, errorHandler: CompletionHandlerFirebaseLoginError) {
		NSLog("Attempt Registration at Firebase")
		FIRAuth.auth()?.createUser(withEmail: email, password: password) { user, error in
			if user?.uid != nil {
				NSLog("Registered at Firebase")
			}
			let errorKey = error?.userInfo[FIRAuthErrorNameKey]

			completion(user?.uid, errorKey, true, errorHandler)
		}
	}
}
