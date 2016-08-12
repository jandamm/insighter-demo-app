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
    
    @IBAction func nextPressed(sender: UIButton) {
        NotificationService.sharedInstance.askForAllowance()

        transitionToNextView()
    }
    
    
    // MARK: - Private Methods
    
    private func transitionToNextView() {
        performSegueWithIdentifier(Segue.OnboardingNotificationToLogin.rawValue, sender: nil)
    }

}
