//
//  JDNavigationDelegate.swift
//  JDTransition
//
//  Created by Jan Dammshäuser on 26.09.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import UIKit

/// Override class, pushAnimator() and popAnimator() to customize transitions
open class JDNavigationDelegate: NSObject, UINavigationControllerDelegate {

	// MARK: - UINavigationControllerDelegate

	public func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {

		switch operation {
		case .pop:
			return popAnimator(from: fromVC, to: toVC)
		case .push:
			return pushAnimator(from: fromVC, to: toVC)
		case .none:
			return nil
		}
	}

	// MARK: - Open Methods

	/// Override to use custom pop transitions
	/// - parameter Default: calls pushAnimator
	open func popAnimator(from fromVC: UIViewController, to toVC: UIViewController) -> JDAnimator? {
		return pushAnimator(from: fromVC, to: toVC)
	}

	/// Override to use custom push transitions
	open func pushAnimator(from fromVC: UIViewController, to toVC: UIViewController) -> JDAnimator? {
		NSLog("[JDTransition] JDNavigationDelegate.pushAnimator(from: _, to: _) is not overridden")
		return nil
	}
}
