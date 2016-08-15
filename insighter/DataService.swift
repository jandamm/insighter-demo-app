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
    
    private let REF_COMP = FIRDatabase.database().reference().child(DBPathKeys.company.rawValue)
    
    
    // MARK: - External Data
    
    let KW: CalendarWeek
    
    
    // MARK: - Initialization
    
    init() {
        KW = CalendarWeek()
    }
    
    
    // MARK: - Global Methods
    
    func addRating(rating: RatingAnswer, lastQuestion: Bool) -> Bool {
        guard let userID = UserLoginService.sharedInstance.userID, let companyID = UserLoginService.sharedInstance.companyID else {
            return false
        }
        
        //TODO
        print("upload answer")
        
        if let comment = rating.comment {
            print("upload comment")
        }
        
        if lastQuestion {
            print("set lastRated")
        }
        
        return true
    }
    
    
    // MARK: - Private Methods
    
    private func uploadData(data: String, toPath path: DBPathKeys.Company, forUser userID: String, atCompany companyID: String) {
        
    }
}
