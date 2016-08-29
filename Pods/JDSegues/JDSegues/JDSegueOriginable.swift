//
//  JDSegueOriginable.swift
//  JDSegues
//
//  Created by Jan Dammshäuser on 29.08.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import Foundation

/// Blueprint for JDSegues which can have an origin for their animation
public protocol JDSegueOriginable: JDSegue {
    
    /// Defines at which point the animation should start
    /// - parameter Default: center of the screen
    var animationOrigin: CGPoint? { get set }
}
