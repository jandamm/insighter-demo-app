//
//  JDAnimationSlideFrom.swift
//  JDTransition
//
//  Created by Jan Dammshäuser on 26.09.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import Foundation

struct JDAnimationSlideFrom {

	static func left(inWindow window: UIView, fromVC: UIViewController, toVC: UIViewController, duration: TimeInterval, options: UIViewAnimationOptions?, completion: @escaping(Bool) -> ()) {
		animate(in: window, fromVC: fromVC, toVC: toVC, duration: duration, options: options, direction: .left, completion: completion)
	}

	static func right(inWindow window: UIView, fromVC: UIViewController, toVC: UIViewController, duration: TimeInterval, options: UIViewAnimationOptions?, completion: @escaping(Bool) -> ()) {
		animate(in: window, fromVC: fromVC, toVC: toVC, duration: duration, options: options, direction: .right, completion: completion)
	}

	static func bottom(inWindow window: UIView, fromVC: UIViewController, toVC: UIViewController, duration: TimeInterval, options: UIViewAnimationOptions?, completion: @escaping(Bool) -> ()) {
		animate(in: window, fromVC: fromVC, toVC: toVC, duration: duration, options: options, direction: .bottom, completion: completion)
	}

	static func top(inWindow window: UIView, fromVC: UIViewController, toVC: UIViewController, duration: TimeInterval, options: UIViewAnimationOptions?, completion: @escaping(Bool) -> ()) {
		animate(in: window, fromVC: fromVC, toVC: toVC, duration: duration, options: options, direction: .top, completion: completion)
	}

	enum Direction {
		case left
		case right
		case bottom
		case top
	}

	private static func animate(in window: UIView, fromVC: UIViewController, toVC: UIViewController, duration: TimeInterval, options opt: UIViewAnimationOptions?, direction: Direction, completion: @escaping(Bool) -> ()) {

		let options = opt ?? .curveLinear
		let centerToVC = origin(fromVC: fromVC, direction: direction)
		let centerFromVC = destination(fromVC: fromVC, direction: direction)

		window.addSubview(toVC.view)

		toVC.view.frame = fromVC.view.frame
		toVC.view.center = centerToVC

		UIView.animate(withDuration: duration, delay: 0, options: options, animations: {

			toVC.view.center = fromVC.view.center
			fromVC.view.center = centerFromVC

		}) { finished in
			completion(finished)
		}
	}

	private static func destination(fromVC: UIViewController, direction: Direction) -> CGPoint {

		let center = fromVC.view.center
		let frame = fromVC.view.frame

		switch direction {
		case .left: return CGPoint(x: center.x + frame.width, y: center.y)
		case .right: return CGPoint(x: center.x - frame.width, y: center.y)
		case .bottom: return CGPoint(x: center.x, y: center.y - frame.height)
		case .top: return CGPoint(x: center.x, y: center.y + frame.height)
		}
	}

	private static func origin(fromVC: UIViewController, direction: Direction) -> CGPoint {

		let center = fromVC.view.center
		let frame = fromVC.view.frame

		switch direction {
		case .left: return CGPoint(x: center.x - frame.width, y: center.y)
		case .right: return CGPoint(x: center.x + frame.width, y: center.y)
		case .bottom: return CGPoint(x: center.x, y: center.y + frame.height)
		case .top: return CGPoint(x: center.x, y: center.y - frame.height)
		}
	}
}
