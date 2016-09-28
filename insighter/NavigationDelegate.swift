//
//  NavigationDelegate.swift
//  insighter
//
//  Created by Jan Dammshäuser on 27.09.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import JDTransition

class NavigationDelegate: JDNavigationDelegate {

	private let animator = JDAnimator()

	override func pushAnimator(from fromVC: UIViewController, to toVC: UIViewController) -> JDAnimator? {
		animator.reset()

		return animator
	}
}
