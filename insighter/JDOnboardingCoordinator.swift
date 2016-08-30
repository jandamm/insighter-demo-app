//
//  JDOnboardingCoordinator.swift
//  insighter
//
//  Created by Jan Dammshäuser on 30.08.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import UIKit

protocol OnboardingDelegate: Coordinator {
    func welcomeBtnPressed()
    func notifBtnPressed()
    func loggedIn()
}

class JDOnboardingCoordinator: NSObject, Coordinator, OnboardingDelegate {
    
    let navigationController: UINavigationController
    
    var childCoordinator = [Coordinator]()
    
    
    // MARK: - Startup
    
    required init(withNavigationController navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showOnboardingWelcome()
    }
    
    
    // MARK: - Delegate
    
    func welcomeBtnPressed() {
        let showNotification = NotificationService.sharedInstance.hasNoAllowance()
        
        if showNotification {
            showOnboardingNotification()
        } else {
            showOnboardingLogin()
        }
    }
    
    func notifBtnPressed() {
        NotificationService.sharedInstance.askForAllowance()
        
        showOnboardingLogin()
    }
    
    func loggedIn() {
        
    }
    
    
    // MARK: - Private Methods
    
    private func showOnboardingWelcome() {
        let vc = OnboardingWelcomeVC()
        
        vc.delegate = self
        
        navigationController.pushViewController(vc, animated: true)
    }
    
    private func showOnboardingNotification() {
        let vc = OnboardingNotificationVC()
        
        vc.delegate = self
        
        navigationController.pushViewController(vc, animated: true)
    }
    
    private func showOnboardingLogin() {
        let vc = OnboardingLoginVC()
        
        vc.delegate = self
        
        navigationController.pushViewController(vc, animated: true)
    }
}
