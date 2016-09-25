//
//  Touchable.swift
//  insighter
//
//  Created by Jan Dammshäuser on 25.09.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import UIKit

protocol Touchable {}

extension Touchable where Self: UIView {

	func getPosition(_ input: Set<UITouch>) -> CGPoint? {
		guard let touch = input.first else {
			return nil
		}

		return touch.location(in: self)
	}
}
