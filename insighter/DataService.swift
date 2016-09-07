//
//  DataService.swift
//  insighter
//
//  Created by Jan Dammshäuser on 08.08.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import Foundation
import Firebase

class DataService {
	static let sharedInstance = DataService()

	private let REF = FIRDatabase.database().reference().child(DBPathKeys.company.rawValue)

	// MARK: - Private Data

	private let REF_COMP = FIRDatabase.database().reference().child(DBPathKeys.company.rawValue)

	private var KW: CalendarWeek!

	private var ratingForAverage = [String: Int]()

	// MARK: - External Data

	// MARK: - Initialization

	// MARK: - Global Methods

	func addRating(rating: RatingAnswer, lastQuestion: Bool) -> Bool {
		guard let userID = UserLoginService.sharedInstance.userID, let company = UserLoginService.sharedInstance.company else {
			return false
		}

		KW = CalendarWeek()

		let data = [rating.UID: rating.rating]
		ratingForAverage[rating.UID] = rating.rating
		uploadRatingData(data, toPath: .rating, forUser: userID, atCompany: company.UID)

		if let comment = rating.comment {
			let data = [rating.UID: comment]
			uploadRatingData(data, toPath: .comment, forUser: userID, atCompany: company.UID)
		}

		NSLog("Uploaded rating data for question: \(rating.UID)")

		if lastQuestion {
			saveRatingToAverage(forCompany: company.UID)
			return UserLoginService.sharedInstance.updateLastRated()
		} else {
			return true
		}
	}

	// MARK: - Private Methods

	private func uploadRatingData(data: [String: AnyObject], toPath path: DBPathKeys.Company, forUser userID: String, atCompany companyID: String) {
		let refToUserRating = REF_COMP.child(companyID).child(path.rawValue).child(KW.stringValue).child(userID)
		refToUserRating.updateChildValues(data)
	}

	private func saveRatingToAverage(forCompany companyID: String) {
		let refToAverage = REF_COMP.child(companyID).child(DBPathKeys.Company.average.rawValue).child(KW.stringValue)

		refToAverage.runTransactionBlock({ currentData -> FIRTransactionResult in
			var data = currentData.value as? [String: [String: Int]] ?? [:]

			let sumKey = DBValueKeys.CompanyAverage.sum.rawValue
			let usersKey = DBValueKeys.CompanyAverage.users.rawValue

			for (questionID, userRating) in self.ratingForAverage {
				let questionData = data[questionID] ?? [:]

				let oldSum = questionData[sumKey] ?? 0
				let oldUsers = questionData[usersKey] ?? 0

				let newSum = oldSum + userRating
				let newUsers = oldUsers + 1

				data[questionID] = [sumKey: newSum, usersKey: newUsers]
			}

			currentData.value = data

			return FIRTransactionResult.successWithValue(currentData)
		}) { error, committed, data in
			if let error = error where !committed {
				NSLog("Could not upload data to average: \(error.localizedDescription)")
				NSLog("Retrying...")
				self.saveRatingToAverage(forCompany: companyID)
			} else if committed {
				NSLog("Uploaded User Rating to Average")
				self.ratingForAverage.removeAll()
			}
		}
	}
}
