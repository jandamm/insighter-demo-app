//
//  Company.swift
//  insighter
//
//  Created by Jan Dammshäuser on 12.08.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import Foundation

struct Company: Equatable {
    let UID: String
    let name: String?
    let users: Int?
    let userNickName: String?
}

func ==(lhs: Company, rhs: Company) -> Bool {
    return lhs.UID == rhs.UID && lhs.name == rhs.name && lhs.users == rhs.users && lhs.userNickName == rhs.userNickName
}
