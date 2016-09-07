//
//  NotificationService.swift
//  insighter
//
//  Created by Jan Dammshäuser on 12.08.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import UIKit

class NotificationService {
	static let sharedInstance = NotificationService()

	private let APP = UIApplication.sharedApplication()

	// MARK: - External Methods

	func hasNoAllowance() -> Bool {
		return APP.currentUserNotificationSettings()?.types == UIUserNotificationType.None
	}

	func askForAllowance() {
		APP.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil))
	}

	func setupNotifications() {
		APP.cancelAllLocalNotifications()
		APP.applicationIconBadgeNumber = 0

		let weekDay = RemoteConfig.sharedInstance.getInt(forKey: .Notif_Trigger_Weekday)
		let hour = RemoteConfig.sharedInstance.getInt(forKey: .Notif_Trigger_Hour)

		addNotification(onWeekDay: weekDay, atHour: hour)
		NSLog("Added Notification")
	}

	// MARK: - Private Methods

	private func addNotification(onWeekDay weekDay: Int, atHour hour: Int) {
		let notification = UILocalNotification()

		let title = RemoteConfig.sharedInstance.getString(forKey: .Notif_Reminder_Title)
		let body = RemoteConfig.sharedInstance.getString(forKey: .Notif_Reminder_Body)
		let action = RemoteConfig.sharedInstance.getString(forKey: .Notif_Reminder_Action)
		let date = getDate(forWeekDay: weekDay, atHour: hour)

		notification.alertTitle = title
		notification.alertBody = body
		notification.alertAction = action
		notification.fireDate = date
		notification.repeatInterval = .Weekday
		notification.soundName = UILocalNotificationDefaultSoundName
		notification.applicationIconBadgeNumber = 1

		APP.scheduleLocalNotification(notification)
	}

	private func getDate(forWeekDay weekDay: Int, atHour hour: Int) -> NSDate {
		let nowDate = NSDate()
		let nowDateComponents = CALENDAR.components([.Weekday, .Hour], fromDate: nowDate)

		let offset = (weekDay - nowDateComponents.weekday) * 24 + hour - nowDateComponents.hour

		let destDate = nowDate.dateByAddingTimeInterval(Double(offset) * 60 * 60)

		let ratedRelation = UserLoginService.sharedInstance.ratedWeeksRelation(withDate: destDate)

		if destDate.timeIntervalSinceNow < 0 || ratedRelation.contains(.This) {
			return destDate.dateByAddingTimeInterval(7 * 24 * 60 * 60)
		}

		return destDate
	}
}
