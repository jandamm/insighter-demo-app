//
//  ConstantService.swift
//  insighter
//
//  Created by Jan Dammshäuser on 08.08.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import Foundation
import Firebase

class ConstantService {
	static let sharedInstance = ConstantService()

	fileprivate let FIR_REF = FIRDatabase.database().reference().child(DBPathKeys.constant.rawValue)
	fileprivate let NSUD = UserDefaults.standard

	// MARK: - Private Data

	fileprivate var _versionDate = ""

	fileprivate var _ratingQuestions = [String: RatingQuestion]()
	fileprivate var _securityQuestions: [String]?

	// MARK: - External Data

	var ratingQuestions: [RatingQuestion] {
		return Array(_ratingQuestions.values)
	}

	var securityQuestions: [String] {
		return _securityQuestions == nil ? [DBValueKeys.Constant.securityQuestions.error] : _securityQuestions!
	}

	// MARK: - Global Methods

	func initiateConstants(_ completion: CompletionHandlerBool?) {

		versionFromNSUD()

		FIR_REF.child(DBValueKeys.Constant._versionDate.rawValue).observeSingleEvent(of: .value, with: { snapshot in
			guard snapshot.exists(), let data = snapshot.value else {
				self.noConnectionToFirebase()
				self.constantsFromNSUD(completion)
				return
			}

			let firebaseVersion = String(describing: data)

			NSLog("[JD] Constants: Local Version: \(self._versionDate); Firebase Version: \(firebaseVersion)")

			if firebaseVersion == self._versionDate {
				self.constantsFromNSUD(completion)
			} else {
				self.constantsFromFirebase(completion)
			}
		})
	}

	// MARK: - NSUserDefaults

	fileprivate func versionFromNSUD() {
		if let versionDate = NSUD.string(forKey: DBValueKeys.Constant._versionDate.rawValue) {
			_versionDate = versionDate
		}
	}

	fileprivate func constantsToNSUD() {
		NSUD.setValue(_versionDate, forKey: DBValueKeys.Constant._versionDate.rawValue)

		let data = NSKeyedArchiver.archivedData(withRootObject: _ratingQuestions)
		NSUD.set(data, forKey: DBValueKeys.Constant.ratingQuestions.rawValue)

		NSUD.setValue(_securityQuestions, forKey: DBValueKeys.Constant.securityQuestions.rawValue)

		let success = NSUD.synchronize()

		NSLog("[JD] Saved Constants from Firebase to NSUD successful: \(success)")
	}

	fileprivate func constantsFromNSUD(_ completion: CompletionHandlerBool?) {
		var pick = 2

		if let data = NSUD.object(forKey: DBValueKeys.Constant.ratingQuestions.rawValue) as? Data, let ratingQuestions = NSKeyedUnarchiver.unarchiveObject(with: data) as? [String: RatingQuestion] {
			_ratingQuestions = ratingQuestions
			pick -= 1
		}

		if let securityQuestions = NSUD.object(forKey: DBValueKeys.Constant.securityQuestions.rawValue) as? [String] {
			_securityQuestions = securityQuestions
			pick -= 1
		}

		let complete = pick == 0

		NSLog("[JD] Got Local Constants completely: \(complete)")

		completion?(complete)
	}

	// MARK: - Firebase

	fileprivate func constantsFromFirebase(_ completion: CompletionHandlerBool?) {
		NSLog("[JD] Getting Constants from Firebase")
		FIR_REF.observeSingleEvent(of: .value, with: { snapshot in
			guard snapshot.exists(), let data = snapshot.value as? [String: AnyObject] else {
				self.noConnectionToFirebase()
				completion?(false)
				return
			}

			var pick = 3

			if let version = data[DBValueKeys.Constant._versionDate.rawValue] {
				self._versionDate = String(describing: version)
				pick -= 1
			}

			if let rawData = data[DBValueKeys.Constant.ratingQuestions.rawValue] as? [String: String] {
				var ratingQuestions = [String: RatingQuestion]()

				for (key, value) in rawData {
					let q = RatingQuestion(uid: key, question: value)
					ratingQuestions[key] = q
				}

				self._ratingQuestions = ratingQuestions
				pick -= 1
			}

			if let securityQuestions = data[DBValueKeys.Constant.securityQuestions.rawValue] as? [String: AnyObject] {
				self._securityQuestions = Array(securityQuestions.keys)
				pick -= 1
			}

			let complete = pick == 0

			NSLog("[JD] Got Constants from Firebase completely: \(complete)")

			self.constantsToNSUD()
			completion?(complete)
		})
	}

	// MARK: - Private Methods

	fileprivate func noConnectionToFirebase() {
		NSLog("[JD] Constants: No connection to Firebase")
	}
}
