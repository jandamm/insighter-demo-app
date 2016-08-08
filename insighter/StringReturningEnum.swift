//
//  StringReturningEnum.swift
//  insighter
//
//  Created by Jan Dammshäuser on 08.08.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import Foundation

protocol StringReturningEnum {
    var value: String { get }
    
}

extension StringReturningEnum {
    
    var value: String {
        return "\(self)"
    }
    
}
