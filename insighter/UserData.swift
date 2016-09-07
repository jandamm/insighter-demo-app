//
//  UserData.swift
//  insighter
//
//  Created by Jan Dammshäuser on 09.08.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import Foundation

struct UserData: Equatable, FIRUploadable {
    let UID: String
    let company: String?
    let lastRated: CalendarWeek
    let previousRated: CalendarWeek
    let securityQuestion: String?
    let securityAnswer: String?

    // MARK: - Initialization

    init(UID: String, company: String?, lastRated: NSTimeInterval?, previousRated: NSTimeInterval?, securityQuestion: String?, securityAnswer: String?) {
        self.UID = UID
        self.company = company
        self.securityAnswer = securityAnswer
        self.securityQuestion = securityQuestion

        let lastRated = lastRated == nil ? 0 : lastRated!
        let lastRatedDate = NSDate(timeIntervalSince1970: lastRated)
        self.lastRated = CalendarWeek(withNSDate: lastRatedDate)

        let previousRated = previousRated == nil ? 0 : previousRated!
        let previousRatedDate = NSDate(timeIntervalSince1970: previousRated)
        self.previousRated = CalendarWeek(withNSDate: previousRatedDate)
    }

    // MARK: - FIRUploadable

    var FIR_PATH: String {
        return "\(DBPathKeys.user.rawValue)/\(UID)"
    }

    var uploadData: [String: AnyObject] {
        let key = DBValueKeys.User.self
        var out = [String: AnyObject]()

        if let company = company {
            out[key.company.rawValue] = company
        }
        if lastRated.timeIntervalSince1970 > 0 {
            out[key.lastRated.rawValue] = lastRated.timeIntervalSince1970
        }
        if previousRated.timeIntervalSince1970 > 0 {
            out[key.previousRated.rawValue] = previousRated.timeIntervalSince1970
        }
        if let securityQuestion = securityQuestion {
            out[key.securityQuestion.rawValue] = securityQuestion
        }
        if let securityAnswer = securityAnswer {
            out[key.securityAnswer.rawValue] = securityAnswer
        }

        return out
    }
}

func ==(lhs: UserData, rhs: UserData) -> Bool {
    return lhs.UID == rhs.UID && lhs.company == rhs.company && lhs.lastRated == rhs.lastRated && lhs.securityQuestion == rhs.securityQuestion && lhs.securityAnswer == rhs.securityAnswer
}
