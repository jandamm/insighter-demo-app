//
//  JDSegueSlideFromX.swift
//  JDSegues
//
//  Created by Jan Dammshäuser on 29.08.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import UIKit

/// Segue where the next screen slides in from left.
@objc
public class JDSegueSlideFromLeft: JDSegueSlideFromRight {
    override var direction: JDSegueSlideFromRight.Direction {
        return .Left
    }
}

/// Segue where the next screen slides in from top.
@objc
public class JDSegueSlideFromTop: JDSegueSlideFromRight {
    override var direction: JDSegueSlideFromRight.Direction {
        return .Top
    }
}

/// Segue where the next screen slides in from bottom.
@objc
public class JDSegueSlideFromBottom: JDSegueSlideFromRight {
    override var direction: JDSegueSlideFromRight.Direction {
        return .Bottom
    }
}

/// Segue where the next screen slides in from right.
@objc
public class JDSegueSlideFromRight: UIStoryboardSegue, JDSegueDelayable {
    
    /// Time the transition animation takes
    /// - parameter Default: 0.5 seconds
    public var transitionTime: NSTimeInterval = 0.5
    
    /// Time the transition animation is delayed after calling
    /// - parameter Default: 0 seconds
    public var transitionDelay: NSTimeInterval = 0
    
    /// Animation Curve
    /// - parameter Default: CurveLinear
    public var animationOption: UIViewAnimationOptions = .CurveLinear
    
    var direction: Direction {
        return .Right
    }
    
    enum Direction {
        case Left
        case Right
        case Bottom
        case Top
    }
    
    public override func perform() {
        let sourceVC = sourceViewController
        let destinationVC = destinationViewController
        
        setupScreens()
        
        destinationVC.view.center = destinationCenter
        
        delay() {
            sourceVC.view.window!.addSubview(destinationVC.view)
            
            UIView.animateWithDuration(self.transitionTime, delay: 0, options: self.animationOption, animations: {

                destinationVC.view.center = self.sourceViewController.view.center
                sourceVC.view.center = self.sourceCenter
                
            }) { finished in
                
                self.finishSegue(nil)
            }
        }
    }
    
    
    var sourceCenter: CGPoint {
        let center = sourceViewController.view.center
        let frame = sourceViewController.view.frame
        
        switch direction {
        case .Left: return CGPoint(x: center.x + frame.width, y: center.y)
        case .Right: return CGPoint(x: center.x - frame.width, y: center.y)
        case .Bottom: return CGPoint(x: center.x, y: center.y - frame.height)
        case .Top: return CGPoint(x: center.x, y: center.y + frame.height)
        }
    }
    
    var destinationCenter: CGPoint {
        let center = sourceViewController.view.center
        let frame = sourceViewController.view.frame
        
        switch direction {
        case .Left: return CGPoint(x: center.x - frame.width, y: center.y)
        case .Right: return CGPoint(x: center.x + frame.width, y: center.y)
        case .Bottom: return CGPoint(x: center.x, y: center.y + frame.height)
        case .Top: return CGPoint(x: center.x, y: center.y - frame.height)
        }
    }
}
