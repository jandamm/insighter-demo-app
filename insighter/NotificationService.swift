//
//  NotificationService.swift
//  insighter
//
//  Created by Jan Dammshäuser on 12.08.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import UIKit

class NotificationService {
	static let shared = NotificationService()

	fileprivate let APP = UIApplication.shared

	// MARK: - External Methods

	func hasNoAllowance() -> Bool {
		return APP.currentUserNotificationSettings?.types == UIUserNotificationType()
	}

	func askForAllowance() {
		APP.registerUserNotificationSettings(UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil))
	}

	func setupNotifications() {
		APP.cancelAllLocalNotifications()
		APP.applicationIconBadgeNumber = 0

		let weekDay = RemoteConfig.shared.getInt(forKey: .Notif_Trigger_Weekday)
		let hour = RemoteConfig.shared.getInt(forKey: .Notif_Trigger_Hour)

		addNotification(onWeekDay: weekDay, atHour: hour)
		NSLog("[JD] Added Notification")
	}

	// MARK: - Private Methods

	fileprivate func addNotification(onWeekDay weekDay: Int, atHour hour: Int) {
		let notification = UILocalNotification()

		let title = RemoteConfig.shared.getString(forKey: .Notif_Reminder_Title)
		let body = RemoteConfig.shared.getString(forKey: .Notif_Reminder_Body)
		let action = RemoteConfig.shared.getString(forKey: .Notif_Reminder_Action)
		let date = getDate(forWeekDay: weekDay, atHour: hour)

		notification.alertTitle = title
		notification.alertBody = body
		notification.alertAction = action
		notification.fireDate = date
		notification.repeatInterval = .weekday
		notification.soundName = UILocalNotificationDefaultSoundName
		notification.applicationIconBadgeNumber = 1

		APP.scheduleLocalNotification(notification)
	}

	fileprivate func getDate(forWeekDay weekDay: Int, atHour hour: Int) -> Date {
		let nowDate = Date()
		let nowDateComponents = (CALENDAR as NSCalendar).components([.weekday, .hour], from: nowDate)

		let offset = (weekDay - nowDateComponents.weekday!) * 24 + hour - nowDateComponents.hour!

		let destDate = nowDate.addingTimeInterval(Double(offset) * 60 * 60)

		let ratedRelation = UserLoginService.shared.ratedWeeksRelation(withDate: destDate)

		if destDate.timeIntervalSinceNow < 0 || ratedRelation.contains(.this) {
			return destDate.addingTimeInterval(7 * 24 * 60 * 60)
		}

		return destDate
	}
}
