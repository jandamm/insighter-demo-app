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

    private let errorUID = "<no uid>"
    private let errorQuestion = "Something went wrong."

    private var _uid: String!
    private var _question: String!

    // MARK: - Global Data

    var uid: String {
        return _uid == nil ? errorUID : _uid
    }

    var question: String {
        let company = UserLoginService.sharedInstance.company.name ?? "Error"
        return _question == nil ? errorQuestion : _question.stringByReplacingOccurrencesOfString("[company]", withString: company)
    }

    // MARK: - Initialization

    init(uid: String, question: String) {
        _uid = uid
        _question = question
    }

    // MARK: - NSCoding

    override init() {}

    convenience required init?(coder aDecoder: NSCoder) {
        self.init()
        self._uid = aDecoder.decodeObjectForKey("uid") as? String
        self._question = aDecoder.decodeObjectForKey("question") as? String
    }

    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self._uid, forKey: "uid")
        aCoder.encodeObject(self._question, forKey: "question")
    }
}
