//
//  JDAppCoordinator.swift
//  insighter
//
//  Created by Jan Dammshäuser on 30.08.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import UIKit

class JDAppCoordinator: NSObject, Coordinator, JDOnboardingCoordinatorDelegate, JDLoginCoordinatorDelegate {

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
        
        let coordinator = JDLoginCoordinator(withNavigationController: navigationController)
        
        coordinator.delegate = self
        
        childCoordinator.append(coordinator)
        
        coordinator.start()
    }
    
    func loginEnded<C where C: NSObject, C: Coordinator>(finishedCoordinator: C) {
        removeSubCoordinator(finishedCoordinator)
        
        getInitialDataWithIntro(userDataOnly: true)
    }
    
    
    // MARK: - Private Methods
    
    private func transitionToNextView() {
        
        
        if !_userLoggedIn {
            let onboardingCoordinator = JDOnboardingCoordinator(withNavigationController: navigationController)
            
            childCoordinator.append(onboardingCoordinator)
            
            onboardingCoordinator.delegate = self
            
            onboardingCoordinator.start()
        } else {
            print("question or main")
            
            UserLoginService.sharedInstance.signOutUser()
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
    
    private func showIntro(animate: Bool) {
        let vc = IntroVC()
        
        vc.animate = animate
        
        navigationController.pushViewController(vc, animated: true)
    }
    
}
