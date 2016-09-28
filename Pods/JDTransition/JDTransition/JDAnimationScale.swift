//
//  JDAnimationScale.swift
//  JDTransition
//
//  Created by Jan Dammshäuser on 26.09.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import Foundation

struct JDAnimationScale {

	static func out(inWindow window: UIView, fromVC: UIViewController, toVC: UIViewController, duration: TimeInterval, options opt: UIViewAnimationOptions?, completion: @escaping(Bool) -> ()) {

		window.addSubview(toVC.view)
		window.sendSubview(toBack: toVC.view)

		toVC.view.frame = fromVC.view.frame

		let options = opt ?? .curveEaseOut

		UIView.animate(withDuration: duration, delay: 0, options: options, animations: {
			fromVC.view.transform = CGAffineTransform(scaleX: 0.05, y: 0.05)
		}) { finished in
			completion(finished)
			fromVC.view.transform = CGAffineTransform(scaleX: 1, y: 1)
		}
	}

	static func `in`(inWindow window: UIView, fromVC: UIViewController, toVC: UIViewController, duration: TimeInterval, options opt: UIViewAnimationOptions?, completion: @escaping(Bool) -> ()) {

		window.addSubview(toVC.view)

		toVC.view.frame = fromVC.view.frame

		let destCenter = fromVC.view.center
		let options = opt ?? .curveEaseIn

		toVC.view.transform = CGAffineTransform(scaleX: 0.05, y: 0.05)

		UIView.animate(withDuration: duration, delay: 0, options: options, animations: {
			toVC.view.transform = CGAffineTransform(scaleX: 1, y: 1)
			toVC.view.center = destCenter
		}) { finished in
			completion(finished)
		}
	}
}
