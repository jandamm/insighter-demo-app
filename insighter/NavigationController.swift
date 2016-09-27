//
//  NavigationController.swift
//  insighter
//
//  Created by Jan Dammshäuser on 31.08.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {

	override func viewDidLoad() {
		super.viewDidLoad()

		setupNavigationController()
	}

	fileprivate func setupNavigationController() {
		navigationBar.isHidden = true

		disableSwipeBack()
	}

	func disableSwipeBack() {
		interactivePopGestureRecognizer?.isEnabled = false
	}

	func enableSwipeBack() {
		interactivePopGestureRecognizer?.isEnabled = true
	}
}
