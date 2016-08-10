//
//  IntroVC.swift
//  insighter
//
//  Created by Jan Dammshäuser on 21.05.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import UIKit

import Firebase

class IntroVC: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var logoVerticalCenterConstraint: NSLayoutConstraint!
    @IBOutlet weak var loadingSpinnerView: LoadingView!

    
    // MARK: - Private Variables
    
    private var _userLoggedIn: Bool?
    private var _checkedConstants = false
    private var _checkedRemoteConfig = false
    
    
    // MARK: - Startup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getConstants()
        getRemoteConfig()
        getUser()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        introAnimationLogo(animated)
        
        print(FIRDatabase.database().reference().child(DBPathKeys.company.rawValue).child("ratingQuestions").childByAutoId().key)
    }

    
    // MARK: - Animation
    
    private func introAnimationLogo(animated: Bool) {
        logoVerticalCenterConstraint.constant = -45
        
        if animated {
            UIView.animateWithDuration(1, animations: {
                self.view.layoutIfNeeded()
                }, completion: { _ in
                    self.loadingSpinnerView.animationStart()
            })
        } else {
            view.layoutIfNeeded()
            loadingSpinnerView.animationStart()
        }
    }
    
    // MARK: - Navigation
    
    private func transitionToNextView() {
        guard let loggedIn = _userLoggedIn where _checkedConstants && _checkedRemoteConfig else {
            return
        }
        
        loadingSpinnerView.animationStop()
        
        let segue: Segue = loggedIn ? .IntroToAuswertung : .IntroToOnboarding
        
        performSegueWithIdentifier(segue.rawValue, sender: nil)
    }
    
    
    // MARK: - Initialization
    
    private func getConstants() {
        ConstantService.sharedInstance.initiateConstants() { successful in
            self._checkedConstants = true
            NSLog("Got Constants successful: \(successful)")
            self.transitionToNextView()
        }
    }
    
    private func getRemoteConfig() {
        RemoteConfig.sharedInstance.getRemoteConfigValues { successful in
            self._checkedRemoteConfig = true
            NSLog("Got Remote Config successful: \(successful)")
            self.transitionToNextView()
        }
    }
    
    private func getUser() {
        UserService.sharedInstance.userIsLoggedIn { loggedIn in
            self._userLoggedIn = loggedIn
            NSLog("User is Logged in: \(loggedIn)")
            self.transitionToNextView()
        }
    }
}

