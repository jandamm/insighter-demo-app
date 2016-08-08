//
//  UserService.swift
//  insighter
//
//  Created by Jan Dammshäuser on 08.08.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import Foundation
import Firebase

class UserService {
    static let sharedInstance = UserService()
    
    private let REF = FIRDatabase.database().reference().child(DBPathKeys.user.value)
    
    // MARK: - Private Data
    
    // MARK: - External Data
    
    // MARK: - Global Methods
    
}
