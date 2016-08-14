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
        addNotification()
    }
    
    
    // MARK: - Private Methods
    
    private func addNotification() {
        let notification = UILocalNotification()
        
        
        
        notification.alertBody = "Body"
        notification.alertAction = "Öffnen"
        notification.fireDate = NSDate().dateByAddingTimeInterval(5)
        
        
        
        
        notification.alertTitle = "Title"
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.applicationIconBadgeNumber = 1
        
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
}
