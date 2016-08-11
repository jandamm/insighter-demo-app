//
//  OnboardingNotificationVC.swift
//  insighter
//
//  Created by Jan Dammshäuser on 09.08.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import UIKit

class OnboardingNotificationVC: UIViewController {
    
    // MARK: - Actions
    
    @IBAction func allowPressed(sender: UIButton) {
        //TODO
        
        UIApplication.sharedApplication().registerUserNotificationSettings(UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil))
        
        let notificationType = UIApplication.sharedApplication().currentUserNotificationSettings()!.types
        
        if notificationType == UIUserNotificationType.None {
            print("disabled")
        } else {
            print("enabled")
            
        }
        
        print("setup notifications")
        print("transition")
    }
    
    @IBAction func forbidPressed(sender: UIButton) {
        transitionToNextView()
    }
    
    
    // MARK: - Private Methods
    
    private func transitionToNextView() {
        performSegueWithIdentifier(Segue.OnboardingNotificationToLogin.rawValue, sender: nil)
    }

}
