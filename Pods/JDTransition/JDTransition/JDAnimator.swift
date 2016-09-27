//
//  JDAnimator.swift
//  JDTransition
//
//  Created by Jan Dammshäuser on 26.09.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import UIKit

/// This class provides all JDTransition animations
public class JDAnimator: NSObject, UIViewControllerAnimatedTransitioning {

	// MARK: - Private Data

	private var animation: AnimationType = .slideFromRight
	private var transitionTime: TimeInterval = 0.4
	private var transitionOptions: UIViewAnimationOptions?

	// MARK: - Public Data

	/// Active animation type
	public var animationType: AnimationType {
		return animation
	}

	/// All animations of JDTransition
	public enum AnimationType {
		case slideFromLeft, slideFromRight, slideFromBottom, slideFromTop
		case scaleIn, scaleOut
	}

	private func animate(in window: UIView, from fromVC: UIViewController, to toVC: UIViewController, completion: @escaping() -> ()) {

		switch animation {
		case .slideFromLeft: JDAnimationSlideFrom.left(inWindow: window, fromVC: fromVC, toVC: toVC, duration: transitionTime, options: transitionOptions) { _ in completion() }
		case .slideFromRight: JDAnimationSlideFrom.right(inWindow: window, fromVC: fromVC, toVC: toVC, duration: transitionTime, options: transitionOptions) { _ in completion() }
		case .slideFromBottom: JDAnimationSlideFrom.bottom(inWindow: window, fromVC: fromVC, toVC: toVC, duration: transitionTime, options: transitionOptions) { _ in completion() }
		case .slideFromTop: JDAnimationSlideFrom.top(inWindow: window, fromVC: fromVC, toVC: toVC, duration: transitionTime, options: transitionOptions) { _ in completion() }
		case .scaleIn: JDAnimationScale.in(inWindow: window, fromVC: fromVC, toVC: toVC, duration: transitionTime, options: transitionOptions) { _ in completion() }
		case .scaleOut: JDAnimationScale.out(inWindow: window, fromVC: fromVC, toVC: toVC, duration: transitionTime, options: transitionOptions) { _ in completion() }
		}
	}

	// MARK: - Setup

	/// Resets all values to initial/default values
	public func reset() {
		animation = .slideFromRight
		transitionTime = 0.4
		transitionOptions = nil
	}

	/// Set the animation type.
	/// - parameter type: default is slideFromRight
	public func animationType(setTo type: AnimationType) {
		animation = type
	}

	/// Set the duration of the animation.
	/// - parameter setTo: default is 0.4
	public func transitionDuration(setTo time: TimeInterval) {
		transitionTime = time
	}

	/// Set the delay of the animation.
	/// - Set nil keep default transitions defaults
	/// - parameter options: default is nil
	public func transitionOptions(setTo options: UIViewAnimationOptions?) {
		transitionOptions = options
	}

	// MARK: - UIViewControllerAnimatedTransitioning

	public func transitionDuration(using context: UIViewControllerContextTransitioning?) -> TimeInterval {
		return transitionTime
	}

	public func animateTransition(using context: UIViewControllerContextTransitioning) {
		guard let toVC = context.viewController(forKey: UITransitionContextViewControllerKey.to) else {
			NSLog("[JDTransition] JDAnimator has no toVC")
			return
		}

		guard let fromVC = context.viewController(forKey: UITransitionContextViewControllerKey.from) else {
			NSLog("[JDTransition] JDAnimator has no fromVC")
			return
		}

		let animationWindow = context.containerView

		animate(in: animationWindow, from: fromVC, to: toVC) {
			context.completeTransition(!context.transitionWasCancelled)
		}
	}
}
