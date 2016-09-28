//
//  JDSegueScaleIn.swift
//  JDSegues
//
//  Created by Jan Dammshäuser on 28.08.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import UIKit

/// Segue where the next screen scales in from a point or the center of the screen.
@objc
open class JDSegueScaleIn: UIStoryboardSegue, JDSegueOriginable {

	/// Defines at which point the animation should start
	/// - parameter Default: center of the screen
	open var animationOrigin: CGPoint?

	/// Time the transition animation takes
	/// - parameter Default: 0.5 seconds
	open var transitionTime: TimeInterval = 0.5

	/// Animation Curve
	/// - parameter Default: CurveLinear
	open var animationOption: UIViewAnimationOptions = .curveLinear

	open override func perform() {
		let fromVC = source
		let toVC = destination

		guard let window = fromVC.view else {
			return NSLog("[JDTransition] JDSegueScaleIn could not get view")
		}

		JDAnimationScale.in(inWindow: window, fromVC: fromVC, toVC: toVC, duration: transitionTime, options: animationOption) { _ in
			self.finishSegue(nil)
		}
	}
}
