//
//  UserData.swift
//  insighter
//
//  Created by Jan Dammshäuser on 09.08.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import Foundation

struct UserData {
    let UID: String
    private let company: String?
    private let lastRated: Double?
    
    init(UID: String, company: String?, lastRated: Double?) {
        self.UID = UID
        self.company = company
        self.lastRated = lastRated
    }
}
