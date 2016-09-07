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

	private let FIR_REF = FIRDatabase.database().reference().child(DBPathKeys.constant.rawValue)
	private let NSUD = NSUserDefaults.standardUserDefaults()

	// MARK: - Private Data

	private var _versionDate = ""

	private var _ratingQuestions = [String: RatingQuestion]()
	private var _securityQuestions: [String]?

	// MARK: - External Data

	var ratingQuestions: [RatingQuestion] {
		return Array(_ratingQuestions.values)
	}

	var securityQuestions: [String] {
		return _securityQuestions == nil ? [DBValueKeys.Constant.securityQuestions.error] : _securityQuestions!
	}

	// MARK: - Global Methods

	func initiateConstants(completion: CompletionHandlerBool?) {

		versionFromNSUD()

		FIR_REF.child(DBValueKeys.Constant._versionDate.rawValue).observeSingleEventOfType(.Value, withBlock: { snapshot in
			guard snapshot.exists(), let data = snapshot.value else {
				self.noConnectionToFirebase()
				self.constantsFromNSUD(completion)
				return
			}

			let firebaseVersion = String(data)

			NSLog("Constants: Local Version: \(self._versionDate); Firebase Version: \(firebaseVersion)")

			if firebaseVersion == self._versionDate {
				self.constantsFromNSUD(completion)
			} else {
				self.constantsFromFirebase(completion)
			}
		})
	}

	// MARK: - NSUserDefaults

	private func versionFromNSUD() {
		if let versionDate = NSUD.stringForKey(DBValueKeys.Constant._versionDate.rawValue) {
			_versionDate = versionDate
		}
	}

	private func constantsToNSUD() {
		NSUD.setValue(_versionDate, forKey: DBValueKeys.Constant._versionDate.rawValue)

		let data = NSKeyedArchiver.archivedDataWithRootObject(_ratingQuestions)
		NSUD.setObject(data, forKey: DBValueKeys.Constant.ratingQuestions.rawValue)

		NSUD.setValue(_securityQuestions, forKey: DBValueKeys.Constant.securityQuestions.rawValue)

		let success = NSUD.synchronize()

		NSLog("Saved Constants from Firebase to NSUD successful: \(success)")
	}

	private func constantsFromNSUD(completion: CompletionHandlerBool?) {
		var pick = 2

		if let data = NSUD.objectForKey(DBValueKeys.Constant.ratingQuestions.rawValue) as? NSData, let ratingQuestions = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? [String: RatingQuestion] {
			_ratingQuestions = ratingQuestions
			pick -= 1
		}

		if let securityQuestions = NSUD.objectForKey(DBValueKeys.Constant.securityQuestions.rawValue) as? [String] {
			_securityQuestions = securityQuestions
			pick -= 1
		}

		let complete = pick == 0

		NSLog("Got Local Constants completely: \(complete)")

		completion?(complete)
	}

	// MARK: - Firebase

	private func constantsFromFirebase(completion: CompletionHandlerBool?) {
		NSLog("Getting Constants from Firebase")
		FIR_REF.observeSingleEventOfType(.Value, withBlock: { snapshot in
			guard snapshot.exists(), let data = snapshot.value as? [String: AnyObject] else {
				self.noConnectionToFirebase()
				completion?(false)
				return
			}

			var pick = 3

			if let version = data[DBValueKeys.Constant._versionDate.rawValue] {
				self._versionDate = String(version)
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

			NSLog("Got Constants from Firebase completely: \(complete)")

			self.constantsToNSUD()
			completion?(complete)
		})
	}

	// MARK: - Private Methods

	private func noConnectionToFirebase() {
		NSLog("Constants: No connection to Firebase")
	}
}
