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

		if fromVC is IntroVC && toVC is QuestionVC {
			animator.animationType(setTo: .slideFromBottom)
		}
		if fromVC is IntroVC && toVC is OnboardingWelcomeVC {
			animator.animationType(setTo: .slideFromTop)
		}
		if fromVC is LoginVC {
			animator.animationType(setTo: .slideFromBottom)
		}
		if fromVC is EvaluationVC && toVC is LoginVC {
			animator.animationType(setTo: .slideFromTop)
		}
		if fromVC is QuestionVC && !(toVC is QuestionVC) {
			animator.animationType(setTo: .slideFromTop)
		}

		return animator
	}
}
