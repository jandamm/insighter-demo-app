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
        let width = bounds.width.native
        maxRating = RemoteConfig.sharedInstance.getDouble(forKey: .Max_Points)
        let pos = position.x.native
        
        var rating = round(pos / width * maxRating)
        
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
        
        delegate.ratingSliderDidStart()
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
        
        delegate.ratingSliderDidEnd()
    }
    
    private func getPosition(input: Set<UITouch>) -> CGPoint? {
        guard let touch = input.first else {
            return nil
        }
        
        return touch.locationInView(superview)
    }
    
    
    // MARK: - Private Methods
    
    private func ratingValueChanged() {
        _rating = Rating(rating: _ratingValue, maxRating: maxRating)
        delegate.ratingSliderDidChange()
        
        setNeedsDisplay()
    }
}
