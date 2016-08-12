//
//  DBValueKeys.swift
//  insighter
//
//  Created by Jan Dammshäuser on 08.08.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import Foundation

struct DBValueKeys {
    
    enum CompanyAverage: StringReturningEnum {
        case rating
        case users
    }
    
    enum CompanyValue: StringReturningEnum {
        case userNickName
        case name
        case users
    }

    enum Constant: StringReturningEnum {
        case _versionDate
        case ratingQuestions
        case securityQuestions
    }
    
    enum Email: StringReturningEnum {
        case company
        case ending
    }
    
    enum User: StringReturningEnum {
        case company
        case lastRated
        case securityAnswer
        case securityQuestion
    }
    
}
