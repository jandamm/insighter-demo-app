//
//  RatingAnswer.swift
//  insighter
//
//  Created by Jan Dammshäuser on 15.08.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import Foundation

struct RatingAnswer: Equatable {
	let UID: String
	let rating: Int
	let comment: String?
}

func ==(lhs: RatingAnswer, rhs: RatingAnswer) -> Bool {
	return lhs.UID == rhs.UID && lhs.rating == rhs.rating && lhs.comment == rhs.comment
}
