//
//  NotificationService.swift
//  insighter
//
//  Created by Jan Dammshäuser on 12.08.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import UIKit

class NotificationService {
	private static var _shared: NotificationService?

	static var shared: NotificationService {
		guard let shared = _shared else {
			_shared = NotificationService()
			return _shared!
		}
		return shared
	}

	static func unload() {
		_shared = nil
	}

	fileprivate let APP = UIApplication.shared

	// MARK: - External Methods

	func hasNoAllowance() -> Bool {
		guard let types = APP.currentUserNotificationSettings?.types else {
			return true
		}
		return types == UIUserNotificationType()
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
		let nowDateWeekday = CALENDAR.component(.weekday, from: nowDate)
		let nowDateHour = CALENDAR.component(.hour, from: nowDate)

		let offset = (weekDay - nowDateWeekday) * 24 + hour - nowDateHour

		let destDate = nowDate.addingTimeInterval(Double(offset) * 60 * 60)

		let lastRated = UserLoginService.shared.lastRated

		if destDate.timeIntervalSinceNow < 0 || lastRated.contains(.this) {
			return destDate.addingTimeInterval(7 * 24 * 60 * 60)
		}

		return destDate
	}
}
