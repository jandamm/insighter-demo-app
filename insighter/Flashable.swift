//
//  Flashable.swift
//  insighter
//
//  Created by Jan Dammshäuser on 15.08.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import UIKit

enum Direction { case `in`, out }

protocol Flashable {}

extension Flashable where Self: UIViewController {

	func flash(_ direction: Direction, speed: Double = 0.0, completion: CompletionHandlerBool?) {

		switch direction {
		case .in:

			let flashView = UIView(frame: view.frame)
			flashView.backgroundColor = UIColor.white
			flashView.alpha = 0.0
			view.addSubview(flashView)

			flashView.translatesAutoresizingMaskIntoConstraints = false
			view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[flashView]|", options: [], metrics: nil, views: ["flashView": flashView]))
			view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[flashView]|", options: [], metrics: nil, views: ["flashView": flashView]))

			UIView.animate(withDuration: speed, animations: {
				flashView.alpha = 1
			}, completion: { complete in
				completion?(complete)
			})

		case .out:
			UIView.animate(withDuration: speed, animations: { _ in
				self.view.subviews.last?.alpha = 0
			}, completion: { complete in
				self.view.subviews.last?.removeFromSuperview()
				completion?(complete)
			})
		}
	}
}
