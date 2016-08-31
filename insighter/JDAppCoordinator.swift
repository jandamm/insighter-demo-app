//
//  JDAppCoordinator.swift
//  insighter
//
//  Created by Jan Dammshäuser on 30.08.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import UIKit

class JDAppCoordinator: JDParentCoordinator, JDAppCoordinatorDelegate {

    private var _userLoggedIn = false
    
    
    // MARK: - Coordinator
    
    override func start() {
        getInitialDataWithIntro(userDataOnly: false)
    }
    
    
    // MARK: - Delegates
    
    func onboardingEnded(finishedCoordinator: JDCoordinator) {
        removeChildCoordinator(finishedCoordinator)
        
        showLogin()
    }
    
    func loginEnded(finishedCoordinator: JDCoordinator) {
        removeChildCoordinator(finishedCoordinator)
        
        getInitialData(userDataOnly: true)
        
        popToRootViewControllerAnimated(true)
    }
    
    
    // MARK: - Private Methods
    
    private func transitionToNextView() {
        
        
        if !_userLoggedIn {
            showOnboarding()
        } else {
            // TODO: - Question or main
            print("question or main")
            
            showEvaluation()
        }
    }
    
    private func getInitialDataWithIntro(userDataOnly userDataOnly: Bool) {
        showIntro()
        
        getInitialData(userDataOnly: userDataOnly)
    }
    
    private func getInitialData(userDataOnly userDataOnly: Bool) {
        let dispatch = dispatch_group_create()
        
        if !userDataOnly {
            dispatch_group_enter(dispatch)
            ConstantService.sharedInstance.initiateConstants() { successful in
                NSLog("Got Constants successful: \(successful)")
                dispatch_group_leave(dispatch)
            }
            
            dispatch_group_enter(dispatch)
            RemoteConfig.sharedInstance.getRemoteConfigValues { successful in
                NSLog("Got Remote Config successful: \(successful)")
                dispatch_group_leave(dispatch)
            }
        }
        
        dispatch_group_enter(dispatch)
        UserLoginService.sharedInstance.checkUserIsLoggedInAndGetData { loggedIn in
            self._userLoggedIn = loggedIn
            NSLog("User is Logged in: \(loggedIn)")
            dispatch_group_leave(dispatch)
        }
        
        dispatch_group_notify(dispatch, dispatch_get_main_queue()) {
            self.transitionToNextView()
        }
    }
    
    
    // MARK: - Show Methods
    
    private func showIntro() {
        let vc = IntroVC()
        
        pushViewController(vc, animated: true)
    }
    
    private func showOnboarding() {
        let onboardingCoordinator = JDOnboardingCoordinator(withNavigationController: navigationController)
        
        onboardingCoordinator.delegate = self
        
        addChildCoordinator(onboardingCoordinator)
        
        onboardingCoordinator.start()
    }
    
    private func showLogin() {
        let coordinator = JDLoginCoordinator(withNavigationController: navigationController)
        
        coordinator.delegate = self
        
        addChildCoordinator(coordinator)
        
        coordinator.start()
    }
    
    private func showQuestion() {
        // TODO: - Implement show question
        print("show question")
    }
    
    private func showEvaluation() {
        let coordinator = JDEvaluationCoordinator(withNavigationController: navigationController)
        
        coordinator.delegate = self
        
        addChildCoordinator(coordinator)
        
        coordinator.start()
    }
}
