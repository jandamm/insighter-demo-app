//
//  IntroVC.swift
//  insighter
//
//  Created by Jan Dammshäuser on 21.05.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import UIKit

class IntroVC: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var logoVerticalCenterConstraint: NSLayoutConstraint!
    @IBOutlet weak var loadingSpinnerView: LoadingView!

    
    // MARK: - Private Variables
    
    private var _userLoggedIn: Bool?
    private var _checkedConstants = false
    
    
    // MARK: - Startup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getConstants()
        getUser()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        introAnimationLogo(animated)
    }

    
    // MARK: - Animation
    
    private func introAnimationLogo(animated: Bool) {
        logoVerticalCenterConstraint.constant = -45
        
        if animated {
            UIView.animateWithDuration(0.5, animations: {
                self.view.layoutIfNeeded()
            })
        } else {
            view.layoutIfNeeded()
        }
    }
    
    // MARK: - Navigation
    
    private func transitionToNextView() {
        guard let loggedIn = _userLoggedIn where _checkedConstants == true else {
            return
        }
        
        if loggedIn {
            performSegueWithIdentifier(Segue.IntroToAuswertung.value, sender: nil)
        } else {
            performSegueWithIdentifier(Segue.IntroToOnboarding.value, sender: nil)
        }
    }
    
    
    // MARK: - Initialization
    
    private func getUser() {
        UserService.sharedInstance.userIsLoggedIn { loggedIn in
            self._userLoggedIn = loggedIn
            NSLog("User is Logged in: \(loggedIn)")
            self.transitionToNextView()
        }
    }
    
    private func getConstants() {
        ConstantService.sharedInstance.initiateConstants() { successful in
            self.loadingSpinnerView.animationStop()
            self._checkedConstants = true
            NSLog("Got Constants successful: \(successful)")
            self.transitionToNextView()
        }
    }
}

