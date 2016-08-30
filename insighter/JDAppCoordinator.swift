//
//  JDAppCoordinator.swift
//  insighter
//
//  Created by Jan Dammshäuser on 30.08.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import UIKit

class JDAppCoordinator: NSObject, Coordinator, JDAppCoordinatorDelegate {

    private var _userLoggedIn = false
    
    
    // MARK: - Coordinator
    
    let navigationController: UINavigationController
    
    var childCoordinator = [NSObject]()
    
    required init(withNavigationController navigationController: UINavigationController) {
        self.navigationController = navigationController
        
        super.init()
    }
    
    func start() {
        getInitialDataWithIntro(userDataOnly: false)
    }
    
    
    // MARK: - Delegates
    
    func onboardingEnded<C where C: NSObject, C: Coordinator>(finishedCoordinator: C) {
        
        removeSubCoordinator(finishedCoordinator)
        
        showLogin()
    }
    
    func loginEnded<C where C: NSObject, C: Coordinator>(finishedCoordinator: C) {
        removeSubCoordinator(finishedCoordinator)
        
        getInitialDataWithIntro(userDataOnly: true)
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
        showIntro(!userDataOnly)
        
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
    
    private func showIntro(animate: Bool) {
        let vc = IntroVC()
        
        vc.animate = animate
        
        navigationController.pushViewController(vc, animated: true)
    }
    
    private func showOnboarding() {
        let onboardingCoordinator = JDOnboardingCoordinator(withNavigationController: navigationController)
        
        onboardingCoordinator.delegate = self
        
        childCoordinator.append(onboardingCoordinator)
        
        onboardingCoordinator.start()
    }
    
    private func showLogin() {
        let coordinator = JDLoginCoordinator(withNavigationController: navigationController)
        
        coordinator.delegate = self
        
        childCoordinator.append(coordinator)
        
        coordinator.start()
    }
    
    private func showQuestion() {
        // TODO: - Implement show question
        print("show question")
    }
    
    private func showEvaluation() {
        let coordinator = JDEvaluationCoordinator(withNavigationController: navigationController)
        
        coordinator.delegate = self
        
        childCoordinator.append(coordinator)
        
        coordinator.start()
    }
}
