//
//  RatingColors.swift
//  insighter
//
//  Created by Jan Dammshäuser on 15.08.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import UIKit

class RatingColors: ColorScheme {
    
    class func color(forRating rating: Int?) -> UIColor {
        guard let rating = rating else {
            return null()
        }
        
        if rating <= 0 {
            return zero()
        } else if rating == 1 {
            return one()
        } else if rating == 2 {
            return two()
        } else if rating == 3 {
            return three()
        } else if rating == 4 {
            return four()
        } else if rating == 5 {
            return five()
        } else if rating == 6 {
            return six()
        } else if rating == 7 {
            return seven()
        } else if rating == 8 {
            return eight()
        } else if rating == 9 {
            return nine()
        }
        
        return ten()
    }
    
    class private func null() -> UIColor {
        return Colors.highlightColor()
    }
    
    class private func zero() -> UIColor {
        return Colors.errorColor()
    }
    
    class private func one() -> UIColor {
        return rgba(246, 97, 97, 1)
    }
    
    class private func two() -> UIColor {
        return rgba(248, 114, 76, 1)
    }
    
    class private func three() -> UIColor {
        return rgba(250, 132, 73, 1)
    }
    
    class private func four() -> UIColor {
        return rgba(252, 149, 70, 1)
    }
    
    class private func five() -> UIColor {
        return Colors.highlightColor()
    }
    
    class private func six() -> UIColor {
        return rgba(222, 170, 77, 1)
    }
    
    class private func seven() -> UIColor {
        return rgba(189, 174, 86, 1)
    }
    
    class private func eight() -> UIColor {
        return rgba(157, 178, 96, 1)
    }
    
    class private func nine() -> UIColor {
        return rgba(124, 182, 105, 1)
    }
    
    class private func ten() -> UIColor {
        return Colors.successColor()
    }
}
