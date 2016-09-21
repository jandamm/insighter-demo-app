//
//  RatingQuestion.swift
//  insighter
//
//  Created by Jan Dammshäuser on 10.08.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import Foundation

class RatingQuestion: NSObject, NSCoding {

	// MARK: - Private Data

	fileprivate let errorUID = "<no uid>"
	fileprivate let errorQuestion = "Something went wrong."

	fileprivate var _uid: String!
	fileprivate var _question: String!

	// MARK: - Internal Data

	var uid: String {
		return _uid == nil ? errorUID : _uid
	}

	var question: String {
		let company = UserLoginService.shared.company?.name ?? "Error"
		return _question == nil ? errorQuestion : _question.replacingOccurrences(of: "[company]", with: company)
	}

	// MARK: - Initialization

	init(uid: String, question: String) {
		_uid = uid
		_question = question
	}

	// MARK: - NSCoding

	override init() {}

	required convenience init?(coder aDecoder: NSCoder) {
		self.init()
		self._uid = aDecoder.decodeObject(forKey: "uid") as? String
		self._question = aDecoder.decodeObject(forKey: "question") as? String
	}

	func encode(with aCoder: NSCoder) {
		aCoder.encode(self._uid, forKey: "uid")
		aCoder.encode(self._question, forKey: "question")
	}
}
