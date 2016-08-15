//
//  Rating.swift
//  insighter
//
//  Created by Jan Dammshäuser on 15.08.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import UIKit

struct Rating {
    let ratingInt: Int
    let color: UIColor
    let slided: Bool
    
    var ratingString: String {
        return "\(ratingInt)"
    }
    
    init(rating: Int?) {
        self.color = RatingColors.color(forRating: rating)
        
        if let rating = rating {
            self.ratingInt = rating
            self.slided = true
        } else {
            self.ratingInt = 0
            self.slided = false
        }
    }
}
