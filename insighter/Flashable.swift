//
//  Flashable.swift
//  insighter
//
//  Created by Jan Dammshäuser on 15.08.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import UIKit

enum Direction { case In, Out }

protocol Flashable {}

extension Flashable where Self: UIViewController {

	func flash(direction: Direction, speed: Double = 0.0, completion: CompletionHandlerBool?) {

		switch direction {
		case .In:

			let flashView = UIView(frame: view.frame)
			flashView.backgroundColor = UIColor.whiteColor()
			flashView.alpha = 0.0
			view.addSubview(flashView)

			flashView.translatesAutoresizingMaskIntoConstraints = false
			view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|[flashView]|", options: [], metrics: nil, views: ["flashView": flashView]))
			view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[flashView]|", options: [], metrics: nil, views: ["flashView": flashView]))

			UIView.animateWithDuration(speed, animations: {
				flashView.alpha = 1
			}, completion: { complete in
				completion?(complete)
			})

		case .Out:
			UIView.animateWithDuration(speed, animations: { _ in
				self.view.subviews.last?.alpha = 0
			}, completion: { complete in
				self.view.subviews.last?.removeFromSuperview()
				completion?(complete)
			})
		}
	}
}
