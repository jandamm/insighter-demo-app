//
//  UserData.swift
//  insighter
//
//  Created by Jan Dammshäuser on 09.08.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import Foundation

struct UserData: Equatable, FIRUploadable {
    let FIR_PATH: String
    let UID: String
    private let company: String?
    private let lastRated: Double?
    private let securityQuestion: String?
    private let securityAnswer: String?
    
    init(UID: String, company: String?, lastRated: Double?, securityQuestion: String?, securityAnswer: String?) {
        self.UID = UID
        self.company = company
        self.lastRated = lastRated
        self.securityQuestion = securityQuestion
        self.securityAnswer = securityAnswer
        
        FIR_PATH = "\(DBPathKeys.user.rawValue)/\(UID)"
    }
    
    
    // MARK: - FIRUploadable
    
    var uploadData: [String : AnyObject] {
        let key = DBValueKeys.User.self
        var out = [String: AnyObject]()
        
        if let company = company {
            out[key.company.rawValue] = company
        }
        if let lastRated = lastRated {
            out[key.lastRated.rawValue] = lastRated
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
