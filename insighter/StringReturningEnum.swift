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
    var error: String { get }
}

extension StringReturningEnum {
    
    var value: String {
        return "\(self)"
    }
    
    var error: String {
        NSLog("\(self)")
        return "__\(self)__".uppercaseString
    }
}
