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
    
    
    // MARK: - Startup
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        introAnimationLogoStart()
    }

    
    // MARK: - Animation
    
    private func introAnimationLogoStart() {
        
        loadingSpinnerView.hidden = true
        
        logoVerticalCenterConstraint.constant = -45
        
        loadingSpinnerView.animationStart()
        
        UIView.animateWithDuration(0.5, animations: {
            self.view.layoutIfNeeded()
            self.loadingSpinnerView.hidden = false
        })
    }
    
    func introAnimationLogoEnd() {
        loadingSpinnerView.animationStop()
    }
}

