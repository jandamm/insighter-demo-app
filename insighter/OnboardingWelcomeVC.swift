//
//  OnboardingWelcomeVC.swift
//  insighter
//
//  Created by Jan Dammshäuser on 17.08.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import UIKit

class OnboardingWelcomeVC: UIViewController {

    weak var delegate: OnboardingDelegate?

    // MARK: - Actions

    @IBAction func nextPressed(sender: UIButton) {
        delegate?.welcomeBtnPressed()
    }
}
