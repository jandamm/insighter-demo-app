//
//  Rating.swift
//  insighter
//
//  Created by Jan Dammshäuser on 15.08.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import UIKit

struct Rating: Equatable {
    let valueInt: Int
    let valueString: String
    
    let fraction: CGFloat
    let color: UIColor
    
    let slided: Bool
    
    
    init(rating: Int?, maxRating: Double) {
        self.color = RatingColors.color(forRating: rating)
        
        if let rating = rating {
            self.valueInt = rating
            self.valueString = "\(rating)"
            self.fraction = CGFloat(Double(rating) / maxRating)
            self.slided = true
        } else {
            self.valueInt = 0
            self.valueString = "0"
            self.fraction = 0.5
            self.slided = false
        }
    }
}

func ==(lhs: Rating, rhs: Rating) -> Bool {
    return lhs.valueInt == rhs.valueInt && lhs.slided == rhs.slided && lhs.fraction == rhs.fraction
}
