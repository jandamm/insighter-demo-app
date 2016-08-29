//
//  JDSegueDelayable.swift
//  JDSegues
//
//  Created by Jan Dammshäuser on 29.08.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import Foundation

/// Blueprint for JDSegues which can be delayed
@objc
public protocol JDSegueDelayable: JDSegue {
    /// Time the transition animation is delayed after calling
    /// - parameter Default: 0 seconds
    var transitionDelay: NSTimeInterval { get set }
}


public extension JDSegueDelayable {
    
    public func delay(delayedCode: () -> ()) {
        
        let delayTime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(transitionDelay * Double(NSEC_PER_SEC)))
        
        dispatch_after(delayTime, dispatch_get_main_queue(), {
            delayedCode()
        })
    }
    
}
