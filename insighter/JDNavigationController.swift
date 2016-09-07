//
//  JDNavigationController.swift
//  insighter
//
//  Created by Jan Dammshäuser on 31.08.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import UIKit

class JDNavigationController: UINavigationController {

	override func viewDidLoad() {
		super.viewDidLoad()

		setupNavigationController()
	}

	private func setupNavigationController() {
		navigationBar.hidden = true

		disableSwipeBack()
	}

	func disableSwipeBack() {
		interactivePopGestureRecognizer?.enabled = false
	}

	func enableSwipeBack() {
		interactivePopGestureRecognizer?.enabled = true
	}
}
