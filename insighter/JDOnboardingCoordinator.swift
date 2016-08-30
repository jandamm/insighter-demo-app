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
}

protocol JDOnboardingCoordinatorDelegate: Coordinator {
    func onboardingEnded<C where C: NSObject, C: Coordinator>(finishedCoordinator: C)
}

class JDOnboardingCoordinator: NSObject, FIRLoginable, Coordinator, OnboardingDelegate {
    
    weak var delegate: JDOnboardingCoordinatorDelegate?
    
    var displayedController: UIViewController?
    
    
    // MARK: - Coordinator
    
    let navigationController: UINavigationController
    
    var childCoordinator = [NSObject]()
    
    required init(withNavigationController navigationController: UINavigationController) {
        self.navigationController = navigationController
        
        super.init()
    }
    
    func start() {
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
        childCoordinator.removeAll()
        
        delegate?.onboardingEnded(self)
    }
    
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
}
