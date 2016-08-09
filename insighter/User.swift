//
//  User.swift
//  insighter
//
//  Created by Jan Dammshäuser on 09.08.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import Foundation

struct User {
    let UID: String
    private let company: String?
    private let lastRated: String?
    
    init(UID: String, company: String?, lastRated: String?) {
        self.UID = UID
        self.company = company
        self.lastRated = lastRated
    }
}
