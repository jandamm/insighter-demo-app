//
//  JDSegue.swift
//  JDSegues
//
//  Created by Jan Dammshäuser on 29.08.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import UIKit

/// Blueprint for JDSegues
@objc
public protocol JDSegue {
    
    /// Animation Curve
    /// - parameter Default: x
    var animationOption: UIViewAnimationOptions { get set }
    
    /// Time the transition animation takes
    /// - parameter Default: x seconds
    var transitionTime: NSTimeInterval { get set }
}

extension JDSegue where Self: UIStoryboardSegue {
    
    func setupScreens() {
        destinationViewController.view.frame = sourceViewController.view.frame
    }
    
    func finishSegue(completion: (() -> Void)?) {
        sourceViewController.presentViewController(destinationViewController, animated: false, completion: completion)
    }
}
