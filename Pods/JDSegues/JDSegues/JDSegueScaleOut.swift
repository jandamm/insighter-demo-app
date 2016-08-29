//
//  JDSegueScaleOut.swift
//  JDSegues
//
//  Created by Jan Dammshäuser on 29.08.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import UIKit

/// Segue where the current screen scales out to a point or the center of the screen.
@objc
public class JDSegueScaleOut: UIStoryboardSegue, JDSegueDelayable, JDSegueOriginable {
    
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
        
        setupScreens()
        
        delay() {
            sourceVC.view.window!.insertSubview(destinationVC.view, belowSubview: sourceVC.view)
        
            UIView.animateWithDuration(self.transitionTime, delay: 0, options: self.animationOption, animations: {
                
                if let center = self.animationOrigin {
                    sourceVC.view.center = center
                }
                
                sourceVC.view.transform = CGAffineTransformMakeScale(0.05, 0.05)
                
            }) { finished in
                
                self.finishSegue() {
                    sourceVC.view.transform = CGAffineTransformMakeScale(1, 1)
                }
            }
        }
    }
}
