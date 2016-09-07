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
            NSLog("RatingSlider delegate was set to \(delegate!)")
        }
    }

    // MARK: - Private Data

    private var isTouching = false

    private var ratingValueMax: Double = 0

    private var ratingValue: Int? {
        didSet {
            ratingValueChanged()
        }
    }

    private var rating = Rating(rating: nil, maxRating: 0.0)

    // MARK: - Startup

    override func awakeFromNib() {
        super.awakeFromNib()

        userInteractionEnabled = true

        setNeedsDisplay()
    }

    override func drawRect(rect: CGRect) {
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

    private func calculateRating(position: CGPoint) {
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

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        guard let position = getPosition(touches) else {
            return
        }

        calculateRating(position)

        delegateMethodsWithShortDelay(touchesBegan: true)
    }

    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        guard let position = getPosition(touches) else {
            return
        }

        calculateRating(position)
    }

    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        guard let position = getPosition(touches) else {
            return
        }

        calculateRating(position)

        delegateMethodsWithShortDelay(touchesBegan: false)
    }

    private func getPosition(input: Set<UITouch>) -> CGPoint? {
        guard let touch = input.first else {
            return nil
        }

        return touch.locationInView(self)
    }

    private func delegateMethodsWithShortDelay(touchesBegan began: Bool) {
        isTouching = began

        let checkAfter = 0.05

        let dispatchTime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(checkAfter * Double(NSEC_PER_SEC)))
        dispatch_after(dispatchTime, dispatch_get_main_queue(), {
            if self.isTouching && began {
                self.delegate?.ratingSliderDidStart()
            } else if !began {
                self.delegate?.ratingSliderDidEnd()
            }
        })
    }

    // MARK: - Private Methods

    private func ratingValueChanged() {
        rating = Rating(rating: ratingValue, maxRating: ratingValueMax)
        delegate?.ratingSliderDidChange()

        setNeedsDisplay()
    }
}
