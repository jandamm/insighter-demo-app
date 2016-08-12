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
}
