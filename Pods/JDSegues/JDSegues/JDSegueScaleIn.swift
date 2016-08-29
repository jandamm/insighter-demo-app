//
//  JDSegueScaleIn.swift
//  JDSegues
//
//  Created by Jan Dammshäuser on 28.08.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import UIKit

/// Segue where the next screen scales in from a point or the center of the screen.
@objc
public class JDSegueScaleIn: UIStoryboardSegue, JDSegueDelayable, JDSegueOriginable {
    
    /// Defines at which point the animation should start
    /// - parameter Default: center of the screen
    public var animationOrigin: CGPoint?
    
    /// Time the transition animation takes
    /// - parameter Default: 0.5 seconds
     public var transitionTime: NSTimeInterval = 0.5
    
    /// Time the transition animation is delayed after calling
    /// - parameter Default: 0 seconds
    public var transitionDelay: NSTimeInterval = 0
    
    /// Animation Curve
    /// - parameter Default: CurveLinear
    public var animationOption: UIViewAnimationOptions = .CurveLinear
    
    
    public override func perform() {
        let sourceVC = sourceViewController
        let destinationVC = destinationViewController
        let destCenter = sourceVC.view.center
        
        setupScreens()
        
        destinationVC.view.transform = CGAffineTransformMakeScale(0.05, 0.05)
        
        if let center = animationOrigin {
            destinationVC.view.center = center
        }
        
        delay() {
            sourceVC.view.addSubview(destinationVC.view)
            
            UIView.animateWithDuration(self.transitionTime, delay: 0, options: self.animationOption, animations: {
                
                destinationVC.view.transform = CGAffineTransformMakeScale(1, 1)
                destinationVC.view.center = destCenter
                
            }) { finished in
                self.finishSegue(nil)
            }
        }
    }
}