//
//  JDAppCoordinator.swift
//  insighter
//
//  Created by Jan Dammshäuser on 30.08.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import UIKit

class JDAppCoordinator: NSObject, Coordinator {

    let navigationController: UINavigationController
    
    var childCoordinator = [Coordinator]()
    
    private var _userLoggedIn = false
    
    required init(withNavigationController navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = IntroVC()
        
        getInitialData()
        
        navigationController.pushViewController(vc, animated: true)
    }
    
    func transitionToNextView() {
        if !_userLoggedIn {
            let onboardingCoordinator = JDOnboardingCoordinator(withNavigationController: navigationController)
            
            childCoordinator.append(onboardingCoordinator)
            
            onboardingCoordinator.start()
        } else {
            print("question or main")
        }
    }
    
    func getInitialData() {
        let dispatch = dispatch_group_create()
        
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
    
}
