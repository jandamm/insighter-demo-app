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
	private static var _shared: UserLoginService?

	static var shared: UserLoginService {
		guard let shared = _shared else {
			_shared = UserLoginService()
			return _shared!
		}
		return shared
	}

	static func unload() {
		_shared = nil
	}

	fileprivate let REF_COMP = FIRDatabase.database().reference().child(DBPathKeys.company.rawValue)
	fileprivate let REF_MAIL = FIRDatabase.database().reference().child(DBPathKeys.email.rawValue)
	fileprivate let REF_USER = FIRDatabase.database().reference().child(DBPathKeys.user.rawValue)

	// MARK: - Private Data

	fileprivate var _userFirebase: FIRUser!
	fileprivate var _userData: UserData!
	fileprivate var _company: Company!
	fileprivate var _emailEndings = [String: String]()
	fileprivate var _userListener: FIRAuthStateDidChangeListenerHandle?

	// MARK: - External Data

	var user: UserData? {
		return _userData
	}

	var company: Company? {
		return _company
	}

	var lastRated: LastRated {
		guard let user = _userData else {
			return LastRated(rawValue: 0)
		}

		return user.lastRated
	}

	func companyID(forEmail mail: String) -> String? {
		let mailParts = mail.components(separatedBy: "@")
		let part = mailParts.count - 1
		let ending = mailParts[part]
		return companyID(forEmailEnding: ending)
	}

	func companyID(forEmailEnding ending: String) -> String? {
		return _emailEndings[ending]
	}

	// MARK: - Internal Methods

	func signOutUser(_ completion: CompletionHandlerBool? = nil) {
		try! FIRAuth.auth()!.signOut()

		_userFirebase = nil
		_userData = nil
		_company = nil

		NSLog("[JD] User logged out")
		getEmailEndingsFromFirebase(completion, forcedCompletionValue: true)
	}

	func checkUserIsLoggedInAndGetData(_ completion: CompletionHandlerBool?) {
		getFIRUser(completion)
	}

	func userRated(withDate date: Date = Date()) -> Bool {
		guard let old = _userData else {
			return false
		}

		let rated = old.lastRated.union(LastRated.this)

		let score = old.score + rated.ratingScore()

		let user = UserData(UID: old.UID, company: old.company, score: score, lastRated: rated.rawValue, lastRatedDate: date.timeIntervalSince1970, securityQuestion: old.securityQuestion, securityAnswer: old.securityAnswer)

		_userData = user

		user.upload()
		NSLog("[JD] Updated lastRated")
		return true
	}

	func registerNewUser(withUserData userData: UserData) {
		userData.upload()
		addUserToCompanyUserCount()
	}

	// MARK: - Private Methods

	fileprivate func addUserToCompanyUserCount() {
		guard let company = _company else {
			return NSLog("[JD] No Company found, could not add user to company count")
		}

		let refToUsers = REF_COMP.child(company.UID).child(DBPathKeys.Company.value.rawValue).child(DBValueKeys.CompanyValue.users.rawValue)

		refToUsers.runTransactionBlock({ currentData -> FIRTransactionResult in
			let users = currentData.value as? Int ?? 0

			currentData.value = users + 1

			return FIRTransactionResult.success(withValue: currentData)
		}) { error, committed, data in
			if let error = error, !committed {
				NSLog("[JD] Could not add user to company count: \(error.localizedDescription)")
				NSLog("[JD] Retrying...")
				self.addUserToCompanyUserCount()
			} else if committed {
				NSLog("[JD] Added new user to company count")
			}
		}
	}

	fileprivate func getUserDataOrEmailEndings(_ completion: CompletionHandlerBool?) {
		let loggedIn = _userFirebase != nil

		if loggedIn {
			getUserDataFromFirebase(completion, forcedCompletionValue: loggedIn)
		} else {
			getEmailEndingsFromFirebase(completion, forcedCompletionValue: loggedIn)
		}
	}

	fileprivate func getFIRUser(_ completion: CompletionHandlerBool?) {
		_userListener = FIRAuth.auth()?.addStateDidChangeListener { auth, user in
			guard self._userFirebase == nil else {
				return
			}

			if let listener = self._userListener {
				FIRAuth.auth()?.removeStateDidChangeListener(listener)
				self._userListener = nil
			}

			self._userFirebase = user
			self.getUserDataOrEmailEndings(completion)
		}
	}

	fileprivate func getUserDataFromFirebase(_ completion: CompletionHandlerBool?, forcedCompletionValue: Bool?) {
		let uid = _userFirebase.uid

		if let user = _userData, user.UID == uid {
			self.complete(completion, withForcedValue: forcedCompletionValue, andRealValue: false)
			return
		}

		NSLog("[JD] Checking User data from Firebase")

		REF_USER.child(uid).observeSingleEvent(of: .value, with: { snapshot in
			guard snapshot.exists(), let data = snapshot.value as? [String: AnyObject] else {
				NSLog("[JD] No User data available in Firebase")
				self.signOutUser() { _ in
					self.complete(completion, withForcedValue: false, andRealValue: false)
				}
				return
			}

			let company = data[DBValueKeys.User.company.rawValue] as? String
			let score = data[DBValueKeys.User.score.rawValue] as? Double
			let lastRated = data[DBValueKeys.User.lastRated.rawValue] as? Int
			let lastRatedDate = data[DBValueKeys.User.lastRatedDate.rawValue] as? Double
			let securityQuestion = data[DBValueKeys.User.securityQuestion.rawValue] as? String
			let securityAnswer = data[DBValueKeys.User.securityAnswer.rawValue] as? String

			let user = UserData(UID: uid, company: company, score: score, lastRated: lastRated, lastRatedDate: lastRatedDate, securityQuestion: securityQuestion, securityAnswer: securityAnswer)

			self._userData = user
			NSLog("[JD] Got User data from Firebase")

			self.getCompanyFromFirebase(completion, forcedCompletionValue: nil)
		})
	}

	fileprivate func getCompanyFromFirebase(_ completion: CompletionHandlerBool?, forcedCompletionValue: Bool?) {
		guard let user = _userData, let uid = user.company else {
			NSLog("[JD] No User or Company found")
			self.complete(completion, withForcedValue: forcedCompletionValue, andRealValue: false)
			return
		}

		let refToValue = REF_COMP.child(uid).child(DBPathKeys.Company.value.rawValue)

		refToValue.observeSingleEvent(of: .value, with: { snapshot in
			guard snapshot.exists(), let data = snapshot.value as? [String: AnyObject] else {
				NSLog("[JD] No Company data available in Firebase")
				self.complete(completion, withForcedValue: forcedCompletionValue, andRealValue: false)
				return
			}

			let name = data[DBValueKeys.CompanyValue.name.rawValue] as? String
			let users = data[DBValueKeys.CompanyValue.users.rawValue] as? Int
			let goodie = data[DBValueKeys.CompanyValue.goodie.rawValue] as? String

			let company = Company(UID: uid, name: name, users: users, goodie: goodie)

			self._company = company
			NSLog("[JD] Got Company data from Firebase")

			self.complete(completion, withForcedValue: forcedCompletionValue, andRealValue: true)
		})
	}

	fileprivate func getEmailEndingsFromFirebase(_ completion: CompletionHandlerBool?, forcedCompletionValue: Bool?) {
		guard _userFirebase == nil && _emailEndings.count == 0 else {
			complete(completion, withForcedValue: forcedCompletionValue, andRealValue: false)
			return
		}

		NSLog("[JD] Checking Email Endings from Firebase")

		REF_MAIL.observeSingleEvent(of: .value, with: { snapshot in
			guard snapshot.exists(), let data = snapshot.value as? [String: [String: String]] else {
				NSLog("[JD] No Email data available in Firebase")
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
			NSLog("[JD] Got Email Endings from Firebase")

			self.complete(completion, withForcedValue: forcedCompletionValue, andRealValue: true)
		})
	}

	fileprivate func complete(_ completion: CompletionHandlerBool?, withForcedValue forced: Bool?, andRealValue value: Bool) {
		let returnValue = forced ?? value

		completion?(returnValue)
	}
}
