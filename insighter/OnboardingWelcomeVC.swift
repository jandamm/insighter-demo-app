//
//  OnboardingWelcomeVC.swift
//  insighter
//
//  Created by Jan Dammshäuser on 17.08.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import UIKit

class OnboardingWelcomeVC: UIViewController {
    
    // MARK: - Actions
    
    @IBAction func nextPressed(sender: UIButton) {
        let showNotification = NotificationService.sharedInstance.hasNoAllowance()
        
        if showNotification {
            transitionToNotification()
        } else {
            transitionToLogin()
        }
    }
    
    
    // MARK: - Private Methods
    
    private func transitionToLogin() {
        performSegueWithIdentifier(Segue.OnboardingWelcomeToLogin.rawValue, sender: nil)
    }
    
    private func transitionToNotification() {
        performSegueWithIdentifier(Segue.OnboardingWelcomeToNotification.rawValue, sender: nil)
    }
    
}
