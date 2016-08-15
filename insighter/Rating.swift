//
//  Rating.swift
//  insighter
//
//  Created by Jan Dammshäuser on 15.08.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import UIKit

struct Rating {
    let rating: Int
    let color: UIColor
    let slided: Bool
    
    var ratingString: String {
        return "\(rating)"
    }
    
    init(rating: Int?) {
        self.color = RatingColors.color(forRating: rating)
        
        if let rating = rating {
            self.rating = rating
            self.slided = true
        } else {
            self.rating = 0
            self.slided = false
        }
    }
}
