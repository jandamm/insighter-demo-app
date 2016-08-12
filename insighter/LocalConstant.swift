//
//  LocalConstant.swift
//  insighter
//
//  Created by Jan Dammshäuser on 08.08.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import Foundation

// Completion Handler
typealias CompletionHandler = () -> ()
typealias CompletionHandlerBool = (Bool) -> ()
typealias CompletionHandlerFirebaseLogin = (String?, AnyObject?, Bool) -> ()


// Segue Identifiers
enum Segue: StringReturningEnum {
    case IntroToOnboarding
    case IntroToAuswertung
    case OnboardingNotificationToLogin
    case OnboardingLoginToAuswertung
    case AuswertungToOnboarding
}
