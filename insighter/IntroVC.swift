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

    
    // MARK: - Startup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewBeforeAnimations()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        logoVerticalCenterConstraint.constant = -45
        
        UIView.animateWithDuration(1, animations: {
            self.view.layoutIfNeeded()
        })
    }

    
    // MARK: - Setup
    
    private func getConstants() {
        ConstantService.sharedInstance.getConstants() { completed in
            self.loadingSpinnerView.animationStop()
        }
    }
    
    private func setupViewBeforeAnimations() {
        loadingSpinnerView.animationStart()
    }

}

