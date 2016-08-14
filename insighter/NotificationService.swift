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
    
    func askForAllowance() {
        APP.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil))
    }
    
    func setupNotifications() {
        APP.cancelAllLocalNotifications()
        APP.applicationIconBadgeNumber = 0
        
        let firstWeekDay = RemoteConfig.sharedInstance.getInt(forKey: .Notif_Trigger_Weekday)
        let firstHour = RemoteConfig.sharedInstance.getInt(forKey: .Notif_Trigger_Hour)
        
        addNotification(onWeekDay: firstWeekDay, atHour: firstHour)
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
        let date = NSDate()
        let today = CALENDAR.components([.Weekday, .Hour], fromDate: date)
        
        let offset = (weekDay - today.weekday) * 24 + hour - today.hour
        
        let destDate = date.dateByAddingTimeInterval(Double(offset) * 60 * 60)
        
        let ratedRelation = UserLoginService.sharedInstance.ratedWeeksRelation(withDate: destDate)
        
        if destDate.timeIntervalSinceNow < 0 || ratedRelation.contains(.This) {
            return destDate.dateByAddingTimeInterval(7 * 24 * 60 * 60)
        }
        
        return destDate
    }
}
