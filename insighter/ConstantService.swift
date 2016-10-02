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
	private static var _shared: ConstantService?

	static var shared: ConstantService {
		guard let shared = _shared else {
			_shared = ConstantService()
			return _shared!
		}
		return shared
	}

	static func unload() {
		_shared = nil
	}

	private let FIR_REF = FIRDatabase.database().reference().child(DBPathKeys.constant.rawValue)
	private let NSUD = UserDefaults.standard

	// MARK: - Private Data

	private var _versionDate = ""

	private var _demoCompany: String?
	private var _mainQuestion: RatingQuestion?
	private var _ratingQuestions = [String: RatingQuestion]()
	private var _securityQuestions: [String]?

	// MARK: - External Data

	var demoCompany: String {
		return _demoCompany ?? "demoCompany"
	}

	var ratingQuestions: [RatingQuestion] {
		return Array(_ratingQuestions.values)
	}

	var securityQuestions: [String] {
		return _securityQuestions == nil ? [DBValueKeys.Constant.securityQuestions.error] : _securityQuestions!
	}

	// MARK: - Internal Methods

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

	private func versionFromNSUD() {
		if let versionDate = NSUD.string(forKey: DBValueKeys.Constant._versionDate.rawValue) {
			_versionDate = versionDate
		}
	}

	private func constantsToNSUD() {
		NSUD.setValue(_versionDate, forKey: DBValueKeys.Constant._versionDate.rawValue)

		NSUD.setValue(_demoCompany, forKey: DBValueKeys.Constant.demoCompany.rawValue)

		if let _mainQuestion = _mainQuestion {
			let mainQ = NSKeyedArchiver.archivedData(withRootObject: _mainQuestion)
			NSUD.set(mainQ, forKey: DBValueKeys.Constant.ratingQuestionMain.rawValue)
		}

		let ratingQ = NSKeyedArchiver.archivedData(withRootObject: _ratingQuestions)
		NSUD.set(ratingQ, forKey: DBValueKeys.Constant.ratingQuestions.rawValue)

		NSUD.setValue(_securityQuestions, forKey: DBValueKeys.Constant.securityQuestions.rawValue)

		let success = NSUD.synchronize()

		NSLog("[JD] Saved Constants from Firebase to NSUD successful: \(success)")
	}

	private func constantsFromNSUD(_ completion: CompletionHandlerBool?) {
		var pick = 4

		if let demoCompany = NSUD.string(forKey: DBValueKeys.Constant.demoCompany.rawValue) {
			_demoCompany = demoCompany
			pick -= 1
		}

		if let data = NSUD.object(forKey: DBValueKeys.Constant.ratingQuestionMain.rawValue) as? Data, let ratingQuestions = NSKeyedUnarchiver.unarchiveObject(with: data) as? RatingQuestion {
			_mainQuestion = ratingQuestions
			pick -= 1
		}

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

	private func constantsFromFirebase(_ completion: CompletionHandlerBool?) {
		NSLog("[JD] Getting Constants from Firebase")
		FIR_REF.observeSingleEvent(of: .value, with: { snapshot in
			guard snapshot.exists(), let data = snapshot.value as? [String: AnyObject] else {
				self.noConnectionToFirebase()
				completion?(false)
				return
			}

			var pick = 5

			if let version = data[DBValueKeys.Constant._versionDate.rawValue] {
				self._versionDate = String(describing: version)
				pick -= 1
			}

			if let rawData = data[DBValueKeys.Constant.demoCompany.rawValue] as? String {
				self._demoCompany = rawData
				pick -= 1
			}

			if let rawData = data[DBValueKeys.Constant.ratingQuestionMain.rawValue] as? String {
				let key = DBValueKeys.Constant.ratingQuestionMain.rawValue

				self._mainQuestion = RatingQuestion(uid: key, question: rawData)
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

	private func noConnectionToFirebase() {
		NSLog("[JD] Constants: No connection to Firebase")
	}
}
