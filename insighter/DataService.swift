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
	static let shared = DataService()

	fileprivate let REF = FIRDatabase.database().reference().child(DBPathKeys.company.rawValue)

	// MARK: - Private Data

	fileprivate var KW: CalendarWeek!

	fileprivate var ratingForAverage = [String: Int]()

    private var _averages: [Average] = []
	private var _userRating: Average.User?

	// MARK: - External Data

	// MARK: - Startup

	// MARK: - Internal Methods

	func getRatings(completion: @escaping() -> Void) {
		guard let companyID = UserLoginService.shared.company?.UID else {
			NSLog("[JD] No Company for Ratings")
			return completion()
		}
		guard let userID = UserLoginService.shared.userID else {
			NSLog("[JD] No User for Ratings")
			return completion()
		}

		let needAverage = _averages.count == 0
		let needUserRating = _userRating == nil

		guard needUserRating || needAverage else {
			return completion()
		}

		let dispatch = DispatchGroup()

		KW = CalendarWeek()

		var keys: [String] = []
		var userAverages: [String: Average.User] = [:]
		var compAverages: [String: Average.Company] = [:]

		if needUserRating {
			dispatch.enter()
			downloadUserRating(forWeek: KW.stringValue, companyID: companyID, userID: userID) { userRating in
				self._userRating = userRating

				dispatch.leave()
			}
		}

		if needAverage {
			let weeks: Int
			if let appDelegate = UIApplication.shared.delegate as? AppDelegate, let width = appDelegate.window?.bounds.width {
				let fitOnScreen = (Double(width) - 64 + 20) / 63
				weeks = Int(fitOnScreen.rounded(.down))
			} else {
				weeks = 5
			}

			for i in 1 ... weeks {
				let kw = KW.calendarWeek(beforeWeeks: i)
				keys.append(kw)
			}

			for key in keys {
				dispatch.enter()
				downloadUserRating(forWeek: key, companyID: companyID, userID: userID) { userRating in
					if let userRating = userRating {
						userAverages[userRating.key] = userRating
					}

					dispatch.leave()
				}

				dispatch.enter()
				downloadCompRating(forWeek: key, companyID: companyID) { companyRating in
					if let companyRating = companyRating {
						compAverages[companyRating.key] = companyRating
					}

					dispatch.leave()
				}
			}
		}

		dispatch.notify(queue: DispatchQueue.main) {
			for key in keys.sorted() {
				let comp = compAverages[key]
				let user = userAverages[key]

				let average = Average(key: key, company: comp, user: user)

				self._averages.append(average)
			}

			completion()
		}
	}

	func addRating(_ rating: RatingAnswer, lastQuestion: Bool) -> Bool {
		guard let userID = UserLoginService.shared.userID, let company = UserLoginService.shared.company else {
			return false
		}

		KW = CalendarWeek()

		let data = [rating.UID: rating.rating]
		ratingForAverage[rating.UID] = rating.rating
		uploadRatingData(data as [String: AnyObject], toPath: .rating, forUser: userID, atCompany: company.UID)

		if let comment = rating.comment {
			let data = [rating.UID: comment]
			uploadRatingData(data as [String: AnyObject], toPath: .comment, forUser: userID, atCompany: company.UID)
		}

		NSLog("[JD] Uploaded rating data for question: \(rating.UID)")

		if lastQuestion {
			saveRatingToAverage(forCompany: company.UID)
			return UserLoginService.shared.updateLastRated()
		} else {
			return true
		}
	}

	// MARK: - Private Methods

	private func downloadCompRating(forWeek key: String, companyID: String, completion: @escaping(Average.Company?) -> Void) {
		let refToAverage = REF.child(companyID).child(DBPathKeys.Company.average.rawValue).child(key)

		refToAverage.observeSingleEvent(of: .value, with: { snapshot in
			guard let data = snapshot.value as? [String: [String: Int]] else {
				NSLog("[JD] Company Average malformed for \(key)")
				return completion(nil)
			}

			var sum: Int = 0
			var users: Int = 0

			for (_, values) in data {
				sum += values["sum"] ?? 0
				users += values["users"] ?? 0
			}

			let average = Average.Company(key: key, answeredQuestions: users, sum: sum)

			completion(average)
		})
	}

	private func downloadUserRating(forWeek key: String, companyID: String, userID: String, completion: @escaping(Average.User?) -> Void) {
		let refToAverage = REF.child(companyID).child(DBPathKeys.Company.rating.rawValue).child(key).child(userID)

		refToAverage.observeSingleEvent(of: .value, with: { snapshot in
			guard let data = snapshot.value as? [String: Int] else {
				NSLog("[JD] User Rating malformed for \(key) / \(userID)")
				return completion(nil)
			}

			let average = Average.User(key: key, answers: data)

			completion(average)
		})
	}

	fileprivate func uploadRatingData(_ data: [String: AnyObject], toPath path: DBPathKeys.Company, forUser userID: String, atCompany companyID: String) {
		let refToUserRating = REF.child(companyID).child(path.rawValue).child(KW.stringValue).child(userID)
		refToUserRating.updateChildValues(data)
	}

	fileprivate func saveRatingToAverage(forCompany companyID: String) {
		let refToAverage = REF.child(companyID).child(DBPathKeys.Company.average.rawValue).child(KW.stringValue)

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

			return FIRTransactionResult.success(withValue: currentData)
		}) { error, committed, data in
			if let error = error, !committed {
				NSLog("[JD] Could not upload data to average: \(error.localizedDescription)")
				NSLog("[JD] Retrying...")
				self.saveRatingToAverage(forCompany: companyID)
			} else if committed {
				NSLog("[JD] Uploaded User Rating to Average")
				self.ratingForAverage.removeAll()
			}
		}
	}
}
