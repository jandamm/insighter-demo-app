//
//  DataService.swift
//  insighter
//
//  Created by Jan Dammshäuser on 08.08.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import Foundation
import Firebase

class DataService {
    static let sharedInstance = DataService()
    
    private let REF = FIRDatabase.database().reference().child(DBPathKeys.company.rawValue)
    
    
    // MARK: - Private Data
    
    // MARK: - External Data
    
    let KW: CalendarWeek
    
    
    // MARK: - Initialization
    
    init() {
        KW = CalendarWeek()
    }
    
    
    // MARK: - Global Methods
    
    func addRating(rating: RatingAnswer) {
        //TODO
        print("save shit: \(rating)")
    }
    
    
    // MARK: - Private Methods
    
}
