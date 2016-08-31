//
//  JDOnboardingCoordinator.swift
//  insighter
//
//  Created by Jan Dammshäuser on 30.08.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import UIKit

protocol OnboardingDelegate: JDCoordinatorDelegate {
    func welcomeBtnPressed()
    func notifBtnPressed()
}

class JDOnboardingCoordinator: JDCoordinator, FIRLoginable, OnboardingDelegate {
    
    weak var delegate: JDOnboardingCoordinatorDelegate?
    
    
    // MARK: - Coordinator
    
    override func start() {
        showOnboardingWelcome()
    }
    
    
    // MARK: - Delegates
    
    func welcomeBtnPressed() {
        let showNotification = NotificationService.sharedInstance.hasNoAllowance()
        
        if showNotification {
            showOnboardingNotification()
        } else {
            onboardingEnded()
        }
    }
    
    func notifBtnPressed() {
        NotificationService.sharedInstance.askForAllowance()
        
        onboardingEnded()
    }
    
    
    // MARK: - Private Methods
    
    private func onboardingEnded() {
        delegate?.onboardingEnded(self)
    }
    
    
    // MARK: - Show Methods
    
    private func showOnboardingWelcome() {
        let vc = OnboardingWelcomeVC()
        
        vc.delegate = self
        
        pushViewController(vc, animated: true)
    }
    
    private func showOnboardingNotification() {
        let vc = OnboardingNotificationVC()
        
        vc.delegate = self
        
        pushViewController(vc, animated: true)
    }
}
