//
//  DBPathKeys.swift
//  insighter
//
//  Created by Jan Dammshäuser on 08.08.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import Foundation

enum DBPathKeys: StringReturningEnum {
    case company
    case constant
    case user
    
    enum Company: StringReturningEnum {
        case average
        case comment
        case rating
        case value
    }
}
