//
//  LocalConstant.swift
//  insighter
//
//  Created by Jan Dammshäuser on 08.08.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import Foundation

let CALENDAR = Calendar(identifier: Calendar.Identifier.iso8601)

// MARK: - Completion Handler

typealias CompletionHandler = () -> ()
typealias CompletionHandlerBool = (Bool) -> ()
typealias CompletionHandlerFirebaseLogin = (String?, String?, Bool, CompletionHandlerFirebaseLoginError) -> ()
typealias CompletionHandlerFirebaseLoginError = ((String?) -> Void)?
