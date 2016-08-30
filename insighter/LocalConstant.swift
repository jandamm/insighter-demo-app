//
//  LocalConstant.swift
//  insighter
//
//  Created by Jan Dammshäuser on 08.08.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import Foundation

let CALENDAR = NSCalendar(calendarIdentifier: NSCalendarIdentifierISO8601)!

// Completion Handler
typealias CompletionHandler = () -> ()
typealias CompletionHandlerBool = (Bool) -> ()
typealias CompletionHandlerFirebaseLogin = (String?, AnyObject?, Bool) -> ()
