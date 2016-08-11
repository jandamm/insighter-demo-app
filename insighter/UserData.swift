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
    let lastRated: Double?
    let securityQuestion: String?
    let securityAnswer: String?
    
    
    // MARK: - FIRUploadable
    
    var FIR_PATH: String {
        return "\(DBPathKeys.user.rawValue)/\(UID)"
    }
    
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
