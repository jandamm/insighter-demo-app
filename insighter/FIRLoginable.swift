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
		NSLog("[JD] Attempt Login with Firebase")
		FIRAuth.auth()?.signIn(withEmail: email, password: password) { user, error in
			if user?.uid != nil {
				NSLog("[JD] Logged in with Firebase")
			}

			let errorKey = self.errorKey(fromError: error)

			completion(user?.uid, errorKey, false, errorHandler)
		}
	}

	func createUser(forEmail email: String, andPassword password: String, completion: @escaping CompletionHandlerFirebaseLogin, errorHandler: CompletionHandlerFirebaseLoginError) {
		NSLog("[JD] Attempt Registration at Firebase")
		FIRAuth.auth()?.createUser(withEmail: email, password: password) { user, error in
			if user?.uid != nil {
				NSLog("[JD] Registered at Firebase")
			}

			let errorKey = self.errorKey(fromError: error)

			completion(user?.uid, errorKey, true, errorHandler)
		}
	}

	private func errorKey(fromError error: Error?) -> String {
		if let userInfo = error?._userInfo as? [String: String], let key = userInfo["error_name"] {
			return key
		}

		return ""
	}
}
