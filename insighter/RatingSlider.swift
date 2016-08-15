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
    
    var delegate: RatingSliderDelegate!
    
    
    // MARK: - Private Data
    
    private var isTouching = false
    
    private var maxRating: Double = 0
    
    private var _ratingValue: Int? {
        didSet {
            ratingValueChanged()
        }
    }
    
    private var _rating = Rating(rating: nil, maxRating: 0.0)
    
    
    // MARK: - Startup

    override func awakeFromNib() {
        super.awakeFromNib()
        
        userInteractionEnabled = true
        setNeedsDisplay()
    }

    override func drawRect(rect: CGRect) {
        InsighterKit.drawSliderView(sliderColor: _rating.color, sliderFraction: _rating.fraction)
    }
    
    
    // MARK: - External Data
    
    var rating: Rating {
        return _rating
    }
    
    
    // MARK: - External Methods
    
    func reset() {
        _ratingValue = nil
    }
    
    
    // MARK: - Calculate Rating
    
    private func calculateRating(position: CGPoint) {
        let width = bounds.width
        maxRating = RemoteConfig.sharedInstance.getDouble(forKey: .Max_Points)
        let pos = position.x
        
        var rating = round(Double(pos / width) * maxRating)
        
        if rating < 0 {
            rating = 0
        } else if rating > maxRating {
            rating = maxRating
        }
        
        let ratingValue = Int(rating)
        
        if _ratingValue == nil || _ratingValue != ratingValue {
            _ratingValue = ratingValue
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
        
        return touch.locationInView(superview)
    }
    
    private func delegateMethodsWithShortDelay(touchesBegan began: Bool) {
        isTouching = began
        
        let yourTimeInSeconds : Double = 0.05
        let dispatchTime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(yourTimeInSeconds * Double(NSEC_PER_SEC)))
        dispatch_after(dispatchTime, dispatch_get_main_queue(), {
            if self.isTouching && began {
                self.delegate.ratingSliderDidStart()
            } else if !began {
                self.delegate.ratingSliderDidEnd()
            }
        })
    }
    
    
    // MARK: - Private Methods
    
    private func ratingValueChanged() {
        _rating = Rating(rating: _ratingValue, maxRating: maxRating)
        delegate.ratingSliderDidChange()
        
        setNeedsDisplay()
    }
}
