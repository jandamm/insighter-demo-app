//
//  OnboardingNotificationVC.swift
//  insighter
//
//  Created by Jan Dammshäuser on 09.08.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import UIKit

class OnboardingNotificationVC: UIViewController {

	weak var delegate: OnboardingDelegate?

	// MARK: - Actions

	@IBAction func nextPressed(_ sender: UIButton) {
		delegate?.notifBtnPressed()
	}
}
