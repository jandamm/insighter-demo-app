//
//  RatingSlider.swift
//  insighter
//
//  Created by Jan Dammshäuser on 15.08.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import UIKit

protocol RatingSliderDelegate {
	func ratingSliderDidStart()
	func ratingSliderDidEnd()
	func ratingSliderDidChange()
}

class RatingSlider: UIView {

	var delegate: RatingSliderDelegate? {
		didSet {
			NSLog("[JD] RatingSlider delegate was set to \(delegate!)")
		}
	}

	// MARK: - Private Data

	fileprivate var isTouching = false

	fileprivate var ratingValueMax: Double = 0

	fileprivate var ratingValue: Int? {
		didSet {
			ratingValueChanged()
		}
	}

	fileprivate var rating = Rating(rating: nil, maxRating: 0.0)

	// MARK: - Startup

	override func awakeFromNib() {
		super.awakeFromNib()

		isUserInteractionEnabled = true

		setNeedsDisplay()
	}

	override func draw(_ rect: CGRect) {
		InsighterKit.drawSliderView(sliderColor: rating.color, width: bounds.width, sliderFraction: rating.fraction)
	}

	// MARK: - External Data

	var value: Rating {
		return rating
	}

	// MARK: - External Methods

	func reset() {
		ratingValue = nil
	}

	// MARK: - Calculate Rating

	fileprivate func calculateRating(_ position: CGPoint) {
		let width = bounds.width
		ratingValueMax = RemoteConfig.sharedInstance.getDouble(forKey: .Max_Points)
		let posX = position.x

		var rating = Double(posX / width) * ratingValueMax
		rating = rating.makeBetween(0, and: ratingValueMax)

		let ratingVal = Int(round(rating))

		if ratingValue == nil || ratingValue != ratingVal {
			ratingValue = ratingVal
		}
	}

	// MARK: - Touches

	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		guard let position = getPosition(touches) else {
			return
		}

		calculateRating(position)

		delegateMethodsWithShortDelay(touchesBegan: true)
	}

	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		guard let position = getPosition(touches) else {
			return
		}

		calculateRating(position)
	}

	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		guard let position = getPosition(touches) else {
			return
		}

		calculateRating(position)

		delegateMethodsWithShortDelay(touchesBegan: false)
	}

	fileprivate func getPosition(_ input: Set<UITouch>) -> CGPoint? {
		guard let touch = input.first else {
			return nil
		}

		return touch.location(in: self)
	}

	fileprivate func delegateMethodsWithShortDelay(touchesBegan began: Bool) {
		isTouching = began

		let checkAfter = 0.05

		let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(checkAfter * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
		DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
			if self.isTouching && began {
				self.delegate?.ratingSliderDidStart()
			} else if !began {
				self.delegate?.ratingSliderDidEnd()
			}
		})
	}

	// MARK: - Private Methods

	fileprivate func ratingValueChanged() {
		rating = Rating(rating: ratingValue, maxRating: ratingValueMax)
		delegate?.ratingSliderDidChange()

		setNeedsDisplay()
	}
}
