//
//  IntExtension.swift
//  insighter
//
//  Created by Jan Dammshäuser on 16.08.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import Foundation

extension Int {
    
    func makeBetween(small: Int, and big: Int) -> Int {
        if self < small {
            return small
        } else if self > big {
            return big
        }
        
        return self
    }
    
}

extension Double {
    
    func makeBetween(small: Double, and big: Double) -> Double {
        if self < small {
            return small
        } else if self > big {
            return big
        }
        
        return self
    }
    
}
