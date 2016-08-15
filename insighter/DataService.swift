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
    private var KW: CalendarWeek!
    
    
    // MARK: - External Data
    
    
    // MARK: - Initialization
    
    
    // MARK: - Global Methods
    
    func addRating(rating: RatingAnswer, lastQuestion: Bool) -> Bool {
        guard let userID = UserLoginService.sharedInstance.userID, let companyID = UserLoginService.sharedInstance.companyID else {
            return false
        }
        
        KW = CalendarWeek()
        
        let data = [rating.UID: rating.rating]
        uploadData(data, toPath: .rating, forUser: userID, atCompany: companyID)
        
        if let comment = rating.comment {
            let data = [rating.UID: comment]
            uploadData(data, toPath: .comment, forUser: userID, atCompany: companyID)
        }
        
        if lastQuestion {
            return UserLoginService.sharedInstance.updateLastRated()
        } else {
            return true
        }
    }
    
    
    // MARK: - Private Methods
    
    private func uploadData(data: [String: AnyObject], toPath path: DBPathKeys.Company, forUser userID: String, atCompany companyID: String) {
        REF_COMP.child(companyID).child(path.rawValue).child(KW.stringValue).child(userID).updateChildValues(data)
    }
}
