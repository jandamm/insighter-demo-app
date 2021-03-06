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
		case sum
		case users
	}

	enum CompanyValue: StringReturningEnum {
		case goodie
		case name
		case users
	}

	enum Constant: StringReturningEnum {
		case _versionDate
		case demoCompany
		case ratingQuestionMain
		case ratingQuestions
		case securityQuestions
	}

	enum Email: StringReturningEnum {
		case company
		case ending
	}

	enum User: StringReturningEnum {
		case company
		case score
		case lastRated
		case lastRatedDate
		case securityAnswer
		case securityQuestion
	}
}
